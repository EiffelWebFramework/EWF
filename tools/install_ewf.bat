@echo off
setlocal
set TMP_EXCLUDE=%~dp0.install_ewf-copydir-exclude
set COPYCMD= xcopy /EXCLUDE:%TMP_EXCLUDE% /I /E /Y 
set TMP_DIR=%~dp0..

echo EIFGENs > %TMP_EXCLUDE%
echo .git >> %TMP_EXCLUDE%
echo .svn >> %TMP_EXCLUDE%

set TMP_TARGET_DIR=%1
if -%TMP_TARGET_DIR%- == -- goto use_eiffel_library
goto start

:use_eiffel_library
if -%EIFFEL_LIBRARY%- == -- goto use_ise_library
set TMP_TARGET_DIR=%EIFFEL_LIBRARY%
goto start

:use_ise_library
set TMP_TARGET_DIR=%ISE_LIBRARY%
goto start

:start
echo Install framework ewf
mkdir %TMP_TARGET_DIR%\contrib\library\web\framework\ewf\ewsgi
echo Install library: ewf/ewsgi
%COPYCMD% %TMP_DIR%\library\server\ewsgi	%TMP_TARGET_DIR%\contrib\library\web\framework\ewf\ewsgi
echo Install library: ewf/libfcgi
%COPYCMD% %TMP_DIR%\library\server\libfcgi	%TMP_TARGET_DIR%\\contrib\library\web\framework\ewf\libfcgi
echo Install library: ewf/wsf
%COPYCMD% %TMP_DIR%\library\server\wsf	%TMP_TARGET_DIR%\contrib\library\web\framework\ewf\wsf
echo Install library: ewf/wsf_extension
%COPYCMD% %TMP_DIR%\library\server\wsf_extension	%TMP_TARGET_DIR%\contrib\library\web\framework\ewf\wsf_extension
echo Install library: ewf/encoding
%COPYCMD% %TMP_DIR%\library\text\encoder	%TMP_TARGET_DIR%\contrib\library\web\framework\ewf\text\encoding

echo Install examples
%COPYCMD% %TMP_DIR%\examples	%TMP_TARGET_DIR%\examples\ewf

echo Install library: error
%COPYCMD% %TMP_DIR%\library\error	%TMP_TARGET_DIR%\library\utility\general\error
echo Install library: http_client
%COPYCMD% %TMP_DIR%\library\client\http_client	%TMP_TARGET_DIR%\library\network\http_client
echo Install library: http
%COPYCMD% %TMP_DIR%\library\protocol\http	%TMP_TARGET_DIR%\library\network\protocol\http
echo Install library: uri_template
%COPYCMD% %TMP_DIR%\library\protocol\uri_template %TMP_TARGET_DIR%\library\text\parser\uri_template

echo Install contrib library: nino
%COPYCMD% %TMP_DIR%\contrib\library\server\nino	%TMP_TARGET_DIR%\contrib\library\network\server\nino

cd %TMP_TARGET_DIR%
call %~dp0\bin\ecf_updater.bat --force --backup --verbose --diff --ise_library .
rem ecf_updater --force --backup --verbose --diff %TMP_TARGET_DIR%

:end
del %TMP_EXCLUDE%

