#!/usr/bin/env python3
"""
Run an xpath selector on an XML document
"""
import sys
from lxml import etree


path = sys.argv[1]
filename = sys.argv[2] if len(sys.argv) >= 3 else None

if filename:
    handle = open(filename, "r")
else:
    handle = sys.stdin

doc = etree.HTML(handle.read())

results = doc.xpath(path)

if not results:
    exit(1)

for elem in results:
    print(etree.tostring(elem, pretty_print=True).decode("utf-8"))
