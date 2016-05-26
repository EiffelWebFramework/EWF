#!/usr/bin/env python
# -*- encoding: utf-8 -*-

"Update the workbook pages to work with Jekyll"

import os

HEADER = """---
layout: default
title: %s
base_url: %s
---
"""

def process_dir (dn,base,rel):
	s = '<ul>\n'
	nodes = os.listdir(dn)
	for file in nodes:
		path = os.path.join (dn, file)
		if not file.startswith('.') and not os.path.isdir(path) and not file.endswith('.mediawiki'):
			originalname = os.path.splitext(file)[0]
			name = " ".join(originalname.replace('-', ' ').replace('_', ' ').split())
			uri = "%s%s" % (base,file)
			if uri.endswith(".md"):
				uri = uri[:-3]
			if file.endswith('.md'):
				print "Processing [%s@%s] %s" % (name, uri, path)
				with open(path, 'r') as f:
					content = f.read()
					if not content.startswith('---'):
						content = (HEADER % (name, rel) + content)
				with open(path, 'w') as f:
					f.write(content.replace('.md)',')')
							.replace('(../','(../../')
							.replace('(/doc/workbook/', '(../')
							.replace('(./', '(../')
						)
				s += '        <li class="page"><a href="%s">%s</a></li>\n' % (uri, name)
	for file in nodes:
		path = os.path.join (dn, file)
		if not file.startswith('.') and os.path.isdir(path): 
			originalname = os.path.splitext(file)[0]
			name = " ".join(originalname.replace('-', ' ').replace('_', ' ').split())
			path = os.path.join (dn, file)
			uri = "%s%s" % (base,file)
			if uri.endswith(".md"):
				uri = uri[:-3]
			print 'Enter', path
			sub_s = process_dir (path, uri + '/', rel + '../')
			if sub_s != '<ul>\n</ul>\n':
				if "%s.md" % (file) in nodes:
					s += '<li class="page folder"><a href="%s">%s/</a>\n' % (uri, name)
				else:
					s += '<li class="folder">%s/\n' % (name)
				s += sub_s
				s += '</li>\n'
	s += '</ul>\n'
	return s

txt = HEADER % ('Workbook', '../') + '\n';
txt += "<h2>Workbook index</h2>\n"
txt += process_dir ("workbook",'', '../../');
with open('workbook.html', 'w') as f:
    f.write(txt)
print 'Done'
