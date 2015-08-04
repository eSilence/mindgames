#!/usr/bin/env python3
import asyncio
import json

import aiohttp
import aiohttp.server
from aiohttp.multidict import MultiDict


class UploadRegistry(dict):
    _instance = None

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super().__new__(cls, *args, **kwargs)
        return cls._instance


class HttpRequestHandler(aiohttp.server.ServerHttpProtocol):

    @asyncio.coroutine
    def handle_request(self, message, payload):
        response = aiohttp.Response(
            self.writer, 200, http_version=message.version
        )
        registry = UploadRegistry()
        if message.method == 'GET':
            file_name = 'file'
            registry[file_name] = 0
            for i in range(1, 101):
                registry[file_name] += 1
                # XXX: sleep only for demonstration purposes
                yield from asyncio.sleep(0.1)
            data = json.dumps({'progress': 100}).encode()
            del registry[file_name]
            self.send_json(response, data)
            yield from response.write_eof()
        else:
            data = json.dumps({'progress': registry.get('file', 100)}).encode()
            self.send_json(response, data)
            yield from response.write_eof()

    def send_json(self, response, data):
        response.add_header('Content-Type', 'text/json')
        response.add_header('Content-Length', str(len(data)))
        response.send_headers()
        response.write(data)


if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    f = loop.create_server(
        lambda: HttpRequestHandler(debug=True, keep_alive=75), '0.0.0.0', '8080')
    srv = loop.run_until_complete(f)
    print('serving on', srv.sockets[0].getsockname())
    try:
        loop.run_forever()
    except KeyboardInterrupt:
        pass
