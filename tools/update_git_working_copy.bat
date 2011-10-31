cd %~dp0..

echo Pull changes from origin master
call git pull origin master

echo Update all submodule recursively
call git submodule update --init --recursive 

echo Checkout master branch for each submodule recursively
call git submodule foreach --recursive git checkout master
