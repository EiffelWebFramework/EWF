#!/bin/sh

cd ..
COMPILE_ALL_BASEDIR=`pwd`
mkdir $COMPILE_ALL_BASEDIR/tests/temp
"$ISE_EIFFEL/tools/spec/$ISE_PLATFORM/bin/compile_all" $1 $2 $3 $4  -ecb -melt -eifgen "$COMPILE_ALL_BASEDIR/tests/temp" -ignore "$COMPILE_ALL_BASEDIR/tests/compile_all.ini"

