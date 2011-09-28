echo off
cd %~dp0..\..\library

echo # Available libraries. > library.index
echo. >> library.index
for /r . %%i in (*.ecf) do echo %%~ni : %%i >> library.index
echo. >> library.index

set CWD=%~dp0
rem remove last trailing slash or backslash
set CWD=%CWD:~0,-1%

rem escape any \ with \\\\ for sed
set CWD=%CWD:\=\\%
set CWD=%CWD:\=\\%
sed -c "s/%CWD%/./g" library.index > library.index.tmp
del library.index
rename library.index.tmp library.index

call:sed test library.index
call:sed example library.index
call:sed wsf library.index

echo. > library.index.tmp
For /F "tokens=* delims=" %%A in (library.index) do echo.%%A >> library.index.tmp
call:rename

goto end

:sed
set SED_ARG="s/^.*%~1.*$//g"
rem echo sed -c -e %SED_ARG% %~2 
sed -c -e %SED_ARG% %~2 > %~2.tmp
del %~2&&rename %~2.tmp %~2
goto EOF

:rename
del library.index&&rename library.index.tmp library.index
goto EOF

:end
type library.index
cd %~dp0
:EOF
