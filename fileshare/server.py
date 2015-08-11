#!/usr/bin/env python3
import asyncio
import json
import os
import os.path
from urllib.parse import unquote

import aiohttp
import aiohttp.server
from aiohttp.multidict import MultiDict


@asyncio.coroutine
def patched_read_chunk(self, size=8192):
    """Reads body part content chunk of the specified size.
    The body part must has `Content-Length` header with proper value.

    :param int size: chunk size

    :rtype: bytearray
    """
    if self._at_eof:
        return b''
    assert self._length is not None, \
        'Content-Length required for chunked read'
    chunk_size = min(size, self._length - self._read_bytes)
    chunk = yield from self._content.read(chunk_size)
    # XXX: read chunk length can be less than chunk_size
    # self._read_bytes += chunk_size
    self._read_bytes += len(chunk)
    if self._read_bytes == self._length:
        self._at_eof = True
        assert b'\r\n' == (yield from self._content.readline()), \
            'reader did not read all the data or it is malformed'
    return chunk

aiohttp.BodyPartReader.read_chunk = patched_read_chunk


class UploadRegistry(dict):
    _instance = None

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super().__new__(cls, *args, **kwargs)
        return cls._instance


class HttpRequestHandler(aiohttp.server.ServerHttpProtocol):

    @asyncio.coroutine
    def handle_request(self, message, payload):
        if message.method == 'POST':
            yield from self.do_POST(message, payload)
        else:
            yield from self.do_GET(message, payload)

    def do_GET(self, message, payload):
        response = aiohttp.Response(self.writer, 200,
                                    http_version=message.version)
        if '?' in message.path:
            query = message.path.split('?')[1]
            _, name = query.split('=')
            registry = UploadRegistry()
            data = json.dumps(
                {
                    'progress': int(registry.get(unquote(name), 0) * 100)
                }).encode()
            yield from self.send_json(response, data)
        else:
            file_path = unquote(os.path.join(*message.path[1:].split('/')))
            if os.path.exists(file_path):
                yield from self.show_file(response, file_path)
            else:
                yield from self.show_form(response)

    def do_POST(self, message, payload):
        reader = aiohttp.MultipartReader(message.headers, payload)
        registry = UploadRegistry()
        file_size = 0
        while True:
            part = yield from reader.next()
            if part is None:
                break

            if not part.filename:
                data = yield from part.read()
                file_size = int(data)
                continue

            registry[part.filename] = 0
            with open(part.filename, 'wb') as out:
                part._length = file_size
                while True:
                    chunk = yield from part.read_chunk()
                    if not chunk:
                        break
                    registry[part.filename] += out.write(chunk) / file_size
            registry[part.filename] = 1

        data = json.dumps({'progress': 100}).encode()
        response = aiohttp.Response(self.writer, 200,
                                    http_version=message.version)
        yield from self.send_json(response, data)

    def show_file(self, response, file_path):
        chunk_size = 64 * 2 ** 10
        with open(file_path, 'rb') as f:
            file_size = os.stat(file_path).st_size
            response.add_header('Content-type', 'application/octet-stream')
            response.add_header('Content-Length', str(file_size))
            response.send_headers()
            while True:
                chunk = f.read(chunk_size)
                if not chunk:
                    break
                response.write(chunk)
        yield from response.write_eof()

    def show_form(self, response):
        """Вывод начальной страницы с формой загрузки."""

        with open('homepage.html', 'rb') as f:
            html = f.read()
            response.add_header('Content-type', 'text/html')
            response.add_header('Content-Length', str(len(html)))
            response.send_headers()
            response.write(html)
        yield from response.write_eof()

    def send_json(self, response, data):
        response.add_header('Content-Type', 'text/json')
        response.add_header('Content-Length', str(len(data)))
        response.send_headers()
        response.write(data)
        yield from response.write_eof()


if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    f = loop.create_server(
        lambda: HttpRequestHandler(debug=True, keep_alive=75), '0.0.0.0',
        '8080')
    srv = loop.run_until_complete(f)
    print('serving on', srv.sockets[0].getsockname())
    try:
        loop.run_forever()
    except KeyboardInterrupt:
        pass
