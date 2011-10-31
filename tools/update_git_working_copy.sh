#!/bin/sh

echo Pull changes from origin master
git pull origin master

echo Update all submodule recursively
git submodule update --init --recursive 

echo Checkout master branch for each submodule recursively
git submodule foreach --recursive git checkout master
