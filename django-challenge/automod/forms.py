#!/usr/bin/env python
# -*- coding: utf-8 -*-

from django import forms

from . import models

form_tmpl = """\
class {model}Form(forms.ModelForm):
\tclass Meta:
\t\tmodel = models.{model}
\t\texclude = []
"""

FORMS = {}

for m in models.MODELS:
    exec(form_tmpl.format(model=m))
    FORMS[m] = locals()['{0}Form'.format(m)]
