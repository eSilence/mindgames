#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import unicode_literals

import datetime
import time

from django.test import LiveServerTestCase
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
import selenium.webdriver.support.expected_conditions as EC

from .models import Users


class SeleniumTests(LiveServerTestCase):

    @classmethod
    def setUpClass(cls):
        profile = webdriver.FirefoxProfile()
        profile.set_preference('network.proxy.type', 0)
        cls.driver = webdriver.Firefox(firefox_profile=profile)
        cls.driver.implicitly_wait(30)
        super(SeleniumTests, cls).setUpClass()

    @classmethod
    def tearDownClass(cls):
        cls.driver.close()
        cls.driver.quit()
        super(SeleniumTests, cls).tearDownClass()

    def setUp(self):
        Users.objects.bulk_create([
            Users(name='User1', paycheck=100, date_joined=datetime.date.today()),
            Users(name='User2', paycheck=150, date_joined=datetime.date.today()),
        ])
        self.driver.get(self.live_server_url)

    def test_load_table(self):
        self._open_table_with_users()

        self._check_nrows(2)
        self._check_user('User1')
        self._check_user('User2')

    def test_add_new_row(self):
        self._open_table_with_users()
        self._add_new_user(name='Semen')

        self._check_nrows(3)
        self._check_user('Semen')

    def test_add_two_new_rows(self):
        self._open_table_with_users()
        self._add_new_user()
        self._add_new_user(name='Max', paycheck='500', date_joined='2013-01-01')

        self._check_nrows(4)
        self._check_user('Semen')
        self._check_user('Max')

    def test_add_new_row_after_several_clicks(self):
        self._open_table_with_users()
        self._open_table_with_rooms()
        self._open_table_with_users()

        self._check_nrows(2)
        self._add_new_user()
        self._check_nrows(3)

    def test_update_field(self):
        field = self._update_name_field()
        field.send_keys(Keys.RETURN)

        self._open_table_with_users()
        self._check_user('Semen')

    def _open_table_with_users(self):
        self._open_table("Users", "name")

    def _open_table_with_rooms(self):
        self._open_table("Rooms", "department")

    def _open_table(self, table, wait_for):
        self.driver.find_element_by_css_selector("a.tname[name={}]".format(table)).click()
        WebDriverWait(self.driver, 10).until(EC.visibility_of_element_located((By.CSS_SELECTOR, "th#{}".format(wait_for))))

    def _add_new_user(self, name='Semen', paycheck=300, date_joined='2014-01-01'):
        self.driver.find_element_by_css_selector("#nameInput").send_keys(name)
        self.driver.find_element_by_css_selector("#paycheckInput").send_keys(paycheck)
        self.driver.find_element_by_css_selector("#date_joinedInput").send_keys(date_joined)
        self.driver.find_element_by_css_selector("button[type=submit]").click()
        time.sleep(0.1)

    def _check_nrows(self, nrows):
        rows = self.driver.find_elements_by_css_selector('tr.dataRow')
        self.assertEqual(len(rows), nrows)

    def _check_user(self, name):
        cells = self.driver.find_elements_by_css_selector('.nameCell input')
        self.assertIn(name, [t.get_attribute('value') for t in cells])

    def _update_name_field(self):
        self._open_table_with_users()
        field = self.driver.find_element_by_css_selector("input[value=User1]")
        field.click()
        field.clear()
        field.send_keys('Semen')
        return field
