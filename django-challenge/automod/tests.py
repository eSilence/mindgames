#!/usr/bin/env python
# -*- coding: utf-8 -*-

from datetime import date, timedelta
import json
import yaml

from django.test import TestCase, Client
from django.utils.http import urlencode

from .models import *
from .helpers import json_prepare


class UsersModelTest(TestCase):
    today = date.today()
    yesterday = today - timedelta(days=1)

    def setUp(self):

        Users.objects.bulk_create([
            Users(name='User1', paycheck=100, date_joined=self.yesterday),
            Users(name='User2', paycheck=200, date_joined=self.today),
        ])

    def test_saving(self):
        users = Users.objects.all()
        self.assertEqual(users.count(), 2)

    def test_saving_and_retrieving_name(self):
        users = Users.objects.all()
        self.assertEqual(users[0].name, 'User1')
        self.assertEqual(users[1].name, 'User2')

    def test_saving_and_retrieving_paycheck(self):
        users = Users.objects.all()
        self.assertEqual(users[0].paycheck, 100)
        self.assertEqual(users[1].paycheck, 200)

    def test_saving_and_retrieving_date_joined(self):
        users = Users.objects.all()
        self.assertEqual(users[0].date_joined, self.yesterday)
        self.assertEqual(users[1].date_joined, self.today)


class RoomsModelTest(TestCase):
    def setUp(self):

        Rooms.objects.bulk_create([
            Rooms(department='Room1', spots=3),
            Rooms(department='Room2', spots=5),
        ])

    def test_saving(self):
        rooms = Rooms.objects.all()
        self.assertEqual(rooms.count(), 2)

    def test_saving_and_retrieving_department(self):
        rooms = Rooms.objects.all()
        self.assertEqual(rooms[0].department, 'Room1')
        self.assertEqual(rooms[1].department, 'Room2')

    def test_saving_and_retrieving_paycheck(self):
        rooms = Rooms.objects.all()
        self.assertEqual(rooms[0].spots, 3)
        self.assertEqual(rooms[1].spots, 5)

class HomepageTest(TestCase):
    def setUp(self):
        self.c = Client()
        self.url = '/'

    def test_model_links(self):
        response = self.c.get(self.url)
        self.assertIn('<a href="javascript:;" name="Users" class="tname">Пользователи</a>', response.content)
        self.assertIn('<a href="javascript:;" name="Rooms" class="tname">Комнаты</a>', response.content)


class JsonApiTest(TestCase):

    today = date.today()

    def setUp(self):
        self.c = Client()
        self.url = '/api/'
        with open("tables", "r") as f:
            self.spec = yaml.load(f)

    def test_get_table_name(self):
        for t in self.spec:
            table = t.capitalize()
            response = self.c.get(self.url, {'table': table})
            data = json.loads(response.content)
            self.assertEqual(data['table'], table)

    def test_get_table_fields(self):
        for t in self.spec:
            table = t.capitalize()
            response = self.c.get(self.url, {'table': table})
            data = json.loads(response.content)
            self._check_table_fields(self.spec[t], data)

    def test_get_table_rows(self):
        Users.objects.create(name='User', paycheck=100, date_joined=self.today)
        response = self.c.get(self.url, {'table': 'Users'})
        data = json.loads(response.content)

        self.assertIn('rows', data)
        self.assertEqual(data['rows'][0]['name'], 'User')
        self.assertEqual(data['rows'][0]['paycheck'], 100)
        self.assertEqual(data['rows'][0]['date_joined'], self.today.isoformat())

    def test_post_creates_new_row(self):
        user = {'name': 'User', 'paycheck': 150, 'date_joined': self.today.isoformat()}
        data = {'table': 'Users'}
        data.update(user)

        response = self.c.post(self.url, data)

        self.assertEqual(Users.objects.all().count(), 1)
        self.assertEqual(Users.objects.get(id=1), Users(id=1, **user))

    def test_post_returns_new_row(self):
        user = {'name': 'User', 'paycheck': 150, 'date_joined': self.today.isoformat()}
        data = {'table': 'Users'}
        data.update(user)

        response = self.c.post(self.url, data)

        data = json.loads(response.content)
        self.assertEqual(data['table'], 'Users')
        user.update({'id': 1})
        self.assertEqual(data['rows'][0], user)

    def test_put_updates_row(self):
        user = Users.objects.create(**{'name': 'User', 'paycheck': 150, 'date_joined': self.today})

        indata = {
            'table': 'Users',
            'id': user.id,
            'field': 'paycheck',
            'value': 250
        }
        response = self.c.put(self.url + '?' + urlencode(indata))
        data = json.loads(response.content)

        self.assertTrue(data['success'])
        self.assertEqual(Users.objects.get(id=user.id).paycheck, 250)

    def _check_table_fields(self, spec, data):
        for i, f in enumerate(spec['fields']):
            self.assertEqual(f, data['fields'][i + 1])
