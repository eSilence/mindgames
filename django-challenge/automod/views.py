#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json

from django.http import HttpResponse, QueryDict
from django.shortcuts import render
from django.views.generic import View
from django.views.decorators.csrf import ensure_csrf_cookie
from django.utils.decorators import method_decorator

from . import models
from .forms import FORMS
from .models import MODELS
from .helpers import json_prepare, to_json

# Create your views here.


def home(request):
    return render(request, 'home.html',
                  {'models': [(m, MODELS[m]['instance']) for m in MODELS]})


class JsonApi(View):

    @method_decorator(ensure_csrf_cookie)
    def get(self, request):
        table = request.GET.get('table')
        if table is None:
            return to_json({})

        model = MODELS[table]
        values = model['instance'].objects.all().values()

        return to_json({
            'table': table,
            'fields': model['fields'],
            'rows': [{k: json_prepare(v)
                      for k, v in r.items()} for r in values],
        })

    def post(self, request):
        postdata = request.POST
        table = postdata.get('table')
        if table is None:
            return to_json({'error': 'Table not found'})

        model = MODELS[table]
        mform = FORMS[table](postdata)
        if mform.is_valid():
            m = model['instance'].objects.create(**mform.cleaned_data)
            return to_json({
                'table': table,
                'fields': model['fields'],
                'rows': [{
                    f['id']: json_prepare(getattr(m, f['id']))
                    for f in model['fields']
                }]
            })
        return to_json({})

    def put(self, request):
        data = request.GET
        table = data.get('table')
        if table is None:
            return to_json({'success': False, 'error': 'Table not found'})

        rowid = data.get('id', None)
        if rowid is None:
            return to_json({'success': False, 'error': 'RowID not found'})

        model = MODELS[table]
        field = data.get('field')
        value = data.get('value')
        try:
            nrows = model['instance'].objects.filter(id=rowid).update(
                **{field: value})
            return to_json({
                'success': nrows == 1,
                'table': table,
                'field': field,
                'value': value
            })
        except:
            return to_json({})
