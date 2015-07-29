#!/usr/bin/env python
# -*- coding: utf-8 -*-

def to_value(c):
    return ord(c) - ord('A') + 1

with open("../data/names.txt") as f:
    l = f.next().replace('"', '').split(',')
    l.sort()
    print sum((i + 1) * sum(map(to_value, word)) for i, word in enumerate(l))
