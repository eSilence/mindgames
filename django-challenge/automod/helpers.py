#!/usr/bin/env python
# -*- coding: utf-8 -*-

import datetime
import json

from django.http import HttpResponse


def json_prepare(v):
    return v.isoformat() if isinstance(v, datetime.date) else v


def to_json(data):
    return HttpResponse(json.dumps(data), content_type='application/json')
