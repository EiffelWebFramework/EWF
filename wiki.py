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

def process_dir (dn,base=''):
	s = '<ul>\n'
	for file in os.listdir(dn):
		if not file.startswith('.') and not file.endswith('.mediawiki'):
			originalname = os.path.splitext(file)[0]
			name = " ".join(originalname.replace('-', ' ').replace('_', ' ').split())
			path = os.path.join (dn, file)
			uri = "%s%s" % (base,file)
			if os.path.isdir(path):
				print 'Enter', path
				s += '<li><a href="%s">%s</a>\n' % (uri, name)
				s += '<ul>'
				s += process_dir (path,uri + '/')
				s += '</ul>'
				s += '</li>'
			else:
				print 'Processing', path
				with open(path, 'r') as f:
					content = f.read()
					if not content.startswith('---'):
						content = (HEADER % (name, '../../') + content)
				with open(path, 'w') as f:
					f.write(content.replace('(./wiki/', '(../').replace('(./', '(../'))
				s += '        <li><a href="%s">%s</a></li>\n' % (uri, name)
	s += '      </ul>'
	return s

wiki = HEADER % ('Wiki', '../') + '\n';
wiki += process_dir ("wiki");
with open('wiki.html', 'w') as f:
    f.write(wiki)
print 'Done'
