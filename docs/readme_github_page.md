---
layout: default
title: readme github page
base_url: ../
---
# EiffelWeb

EiffelWeb is a framework to build web applications in Eiffel.

To get started, check out [http://eiffelwebframework.github.io/EWF](http://eiffelwebframework.github.io/EWF)!

## Documentation

EiffelWeb 's documentation, included in this repo in the root directory, is built with [Jekyll](http://jekyllrb.com) and publicly hosted on GitHub Pages at [http://eiffelwebframework.github.io/EWF](http://eiffelwebframework.github.io/EWF). The docs may also be run locally.

### Running documentation locally

1. If necessary, [install Jekyll](http://jekyllrb.com/docs/installation) (requires v1.x).
2. From the root `/EWF` directory, run `jekyll serve` in the command line.
  - **Windows users:** run `chcp 65001` first to change the command prompt's character encoding ([code page](http://en.wikipedia.org/wiki/Windows_code_page)) to UTF-8 so Jekyll runs without errors.
3. Open [http://localhost:9000](http://localhost:9000) in your browser, and voilà.

Learn more about using Jekyll by reading their [documentation](http://jekyllrb.com/docs/home/).

### Update the wiki pages
1. git remote add -f ewf_wiki https://github.com/EiffelWebFramework/EWF.wiki.git
2. git merge -s ours --no-commit --squash ewf_wiki/master
3. git pull -X subtree=wiki ewf_wiki master
4. then git commit if needed

