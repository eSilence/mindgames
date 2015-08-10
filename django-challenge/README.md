# Django challenge

Автоматическое создание табличек из YAML файла + одностраничное приложение для
работы с ними.

TODO
----
- Тесты Selenium *иногда* падают (проблема на стороне frontend и/или Selenium)
```
    ======================================================================
    FAIL: test_add_new_row (automod.tests_selenium.SeleniumTests)
    ----------------------------------------------------------------------
    Traceback (most recent call last):
      File "/home/vovka/projects/mindgames/django-challenge/automod/tests_selenium.py", line 53, in test_add_new_row
        self._check_nrows(3)
      File "/home/vovka/projects/mindgames/django-challenge/automod/tests_selenium.py", line 100, in _check_nrows
        self.assertEqual(len(rows), nrows)
    AssertionError: 4 != 3

    ======================================================================
    FAIL: test_add_new_row_after_several_clicks (automod.tests_selenium.SeleniumTests)
    ----------------------------------------------------------------------
    Traceback (most recent call last):
      File "/home/vovka/projects/mindgames/django-challenge/automod/tests_selenium.py", line 72, in test_add_new_row_after_several_clicks
        self._check_nrows(3)
      File "/home/vovka/projects/mindgames/django-challenge/automod/tests_selenium.py", line 100, in _check_nrows
        self.assertEqual(len(rows), nrows)
    AssertionError: 4 != 3

    ======================================================================
    FAIL: test_add_two_new_rows (automod.tests_selenium.SeleniumTests)
    ----------------------------------------------------------------------
    Traceback (most recent call last):
      File "/home/vovka/projects/mindgames/django-challenge/automod/tests_selenium.py", line 61, in test_add_two_new_rows
        self._check_nrows(4)
      File "/home/vovka/projects/mindgames/django-challenge/automod/tests_selenium.py", line 100, in _check_nrows
        self.assertEqual(len(rows), nrows)
    AssertionError: 5 != 4
```
- Переписать frontend с использованием Backbone.js
