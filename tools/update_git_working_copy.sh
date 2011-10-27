#!/bin/sh

cd ..
echo Pull changes from origin master
call git pull origin master

echo Update all submodule recursively
call git submodule update --recursive 

echo Checkout master branch for each submodule recursively
call git submodule foreach --recursive git checkout master
