#!/bin/bash

TODAY=`date +%Y-%m-%d`
echo $TODAY
mkdir $TODAY
cd $TODAY
git clone --recursive https://github.com/Eiffel-World/Eiffel-Web-Framework.git EWF_$TODAY
tar czvf EWF_$TODAY.tgz EWF_$TODAY --exclude .git
tar czvf EWF_with_git_$TODAY.tgz EWF_$TODAY
zip -q -r -T EWF_$TODAY.zip EWF_$TODAY -x "*.git*"
\rm -rf EWF_$TODAY
