from django.contrib import admin

# Register your models here.

from .models import MODELS

for m in MODELS:
    admin.site.register(MODELS[m]['instance'])
