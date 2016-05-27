---
layout: default
title: Source structure
base_url: ../../
---
## Currently ##

- LICENSE : file containing the global license
- README : quick README to point to the github project
- doc/
- doc/wiki : clone of the associated github wiki repository
- examples/
- tests/
- library/
- library/server/ewsgi/ewsgi.ecf
- library/server/ewsgi/ewsgi.ecf

Any library/component (in development mode) should follow the following structure (when not needed, there is no need to create the associated folder(s) ):

- **README**
- **COPYRIGHT**
- **LICENSE**
- **.ecf** and **-safe.ecf** : configuration file
- **library/** : the place to put the source code of the related library/component
- **doc/** : notes, documentations, ...
- **tests/** : standard place to put your tests, if you are using Eiffel Software auto-tests, I would suggest to add a new target into the associated .ecf  (instead of building a new .ecf under test/ )
- **examples/** : standard place to put the example
- **build/** : a convenient place to compile your project, using this convention, you can setup utilities such as backup to ignore this folder.
- **resources/** : contains pixmap files, ....
- **install/** : contains installation scripts for each platform
- **data/** : contains eventual data for the related tools

See that we use the singular, since it is an Eiffel convention for naming cluster or folder.
