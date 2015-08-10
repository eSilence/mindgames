from django.conf.urls import patterns, include, url

from django.contrib import admin
admin.autodiscover()

from automod.views import JsonApi

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'challenge.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    url('^$', 'automod.views.home'),
    url('^api/$', JsonApi.as_view()),
    url(r'^admin/', include(admin.site.urls)),
)
