#!/usr/bin/env python
# -*- encoding: utf-8 -*-

"Update the wiki pages to work with Jekyll"

import os

HEADER = """---
layout: default
title: %s
base_url: %s
---
"""

wiki = HEADER % ('Wiki', '../') + '      <ul>\n'
for file in os.listdir('wiki'):
    if not file.startswith('.') and not file.endswith('.mediawiki'):
        originalname = os.path.splitext(file)[0]
        name = " ".join(originalname.replace('-', ' ').replace('_', ' ').split())
        path = os.path.join ('wiki', file)
        print 'Processing', path
        with open(path, 'r') as f:
            content = f.read()
            if not content.startswith('---'):
                content = (HEADER % (name, '../../') + content)
        with open(path, 'w') as f:
            f.write(content.replace('(./wiki/', '(../').replace('(./', '(../'))
        wiki += '        <li><a href="%s">%s</a></li>\n' % (originalname, name)
wiki += '      </ul>'
with open('wiki.html', 'w') as f:
    f.write(wiki)
print 'Done'
