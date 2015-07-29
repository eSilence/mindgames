#!/usr/bin/env python
# -*- coding: utf-8 -*-

from datetime import date

def is_sunday(d):
    return ((d - date(1900, 1, 1)).days + 1) % 7 == 0


def first_days_of_month(year_from, year_to):
    for y in xrange(year_from, year_to + 1):
        for m in xrange(1, 13):
            yield date(y, m ,1)

if __name__ == '__main__':
    print len(filter(is_sunday, first_days_of_month(1901, 2000)))
