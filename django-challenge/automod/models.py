#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import unicode_literals

import yaml

from django.db import models

# Create your models here.


_MODEL_TMPL = """
class {name}(models.Model):
{fields}

\tdef meta(self):
\t\treturn self._meta


\tclass Meta:
\t\tverbose_name = {title!r}
\t\tverbose_name_plural = {title!r}
"""


def _create_field_opts(ftype, **kwargs):
    opts = {}
    if "title" in kwargs:
        opts["verbose_name"] = kwargs["title"]

    if ftype == "char":
        opts["max_length"] = kwargs.get("max_length", 256)

    if "null" in kwargs:
        opts["null"] = kwargs["null"]

    return ", ".join(["{0}={1!r}".format(k, v) for k, v in opts.items()])


def _build_field_factory(**kwargs):

    types = {
        "int": "Integer",
        "char": "Char",
        "date": "Date",
    }

    ftype = kwargs.pop("type")
    if ftype not in types:
        raise NotImplementedError("Type {0!r} is not supported".format(ftype))

    if "id" not in kwargs:
        raise ValueError("Field ID is not set: {val!r}".format(val=kwargs))

    return  "\t{fid} = models.{ftype}Field({opts})".format(
        fid=kwargs["id"],
        ftype=types[ftype],
        opts=_create_field_opts(ftype, **kwargs)
    )


def _generate_fields(fields):
    return "\n".join([_build_field_factory(**v) for v in fields])


def _models_from_dict(data):
    for k, v in data.items():
        name = k.capitalize()
        fields = v.get("fields", [])
        source = _MODEL_TMPL.format(
            name=name,
            title=v.get("title", name),
            fields=_generate_fields(fields)
        )
        yield (name, source, [{'type': 'auto', 'id': 'id', 'title': 'Id'}] + fields)


# Entry point
MODELS = {}
with open("tables", "r") as f:
    __all__ = ['MODELS']
    for name, source, fields_spec in _models_from_dict(yaml.load(f)):
        exec(source)
        __all__.append(name)
        MODELS[name] = {
            'instance': locals()[name],
            'fields': fields_spec
        }

    models.register_models("automod", *[m['instance'] for m in MODELS.values()])
