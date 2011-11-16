echo off
setlocal
cd /d %~dp0..
set COMPILE_ALL_BASEDIR=%CD%
mkdir tests\temp
"%ISE_EIFFEL%\tools\spec\%ISE_PLATFORM%\bin\compile_all.exe" %* -ecb -melt -eifgen "%CD%\tests\temp" -ignore "%CD%\tests\compile_all.ini"

cd %~dp0

endlocal
echo on
