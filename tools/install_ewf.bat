@echo off
setlocal
set TMP_EXCLUDE=%~dp0.install_ewf-copydir-exclude
set COPYCMD= xcopy /EXCLUDE:%TMP_EXCLUDE% /I /E /Y 
set SVNCO=svn checkout 
set TMP_DIR=%~dp0..
set SAFE_MD=call safe_md

echo EIFGENs > %TMP_EXCLUDE%
echo .git >> %TMP_EXCLUDE%
echo .svn >> %TMP_EXCLUDE%

set TMP_TARGET_DIR=%1
if -%TMP_TARGET_DIR%- == -- goto ask_target_dir
goto start

:ask_target_dir
echo Please provide a installation directory (target library)
if -%ISE_LIBRARY%- == -- set ISE_LIBRARY=%EIFFEL_LIBRARY%
if -%ISE_LIBRARY%- == -- set ISE_LIBRARY=%ISE_EIFFEL%
if -%EIFFEL_LIBRARY%- == -- set EIFFEL_LIBRARY=%ISE_LIBRARY%
echo 1: using $EIFFEL_LIBRARY=%EIFFEL_LIBRARY%
echo 2: using $ISE_LIBRARY=%ISE_LIBRARY%
echo 3: using current directory=%CD%\ewf
CHOICE /C 123q /M " > selection:"
if .%ERRORLEVEL%. == .1. goto use_eiffel_library
if .%ERRORLEVEL%. == .2. goto use_ise_library
if .%ERRORLEVEL%. == .3. goto use_current_dir
echo No target directory were specified, you can pass it using the command line
echo Usage: install_ewf {target_directory}
echo Bye ...
goto end

:use_eiffel_library
if -%EIFFEL_LIBRARY%- == -- goto use_ise_library
set TMP_TARGET_DIR=%EIFFEL_LIBRARY%
goto start

:use_ise_library
if -%ISE_LIBRARY%- == -- goto use_current_dir
set TMP_TARGET_DIR=%ISE_LIBRARY%
goto start

:use_current_dir
set TMP_TARGET_DIR=%CD%\ewf
goto start

:start
set TMP_CONTRIB_DIR=%TMP_TARGET_DIR%\contrib

echo Install framework ewf
%SAFE_MD% %TMP_CONTRIB_DIR%\library\web\framework\ewf
echo Install library: ewf/ewsgi
%COPYCMD% %TMP_DIR%\library\server\ewsgi	%TMP_CONTRIB_DIR%\library\web\framework\ewf\ewsgi
echo Install library: ewf/libfcgi
%COPYCMD% %TMP_DIR%\library\server\libfcgi	%TMP_CONTRIB_DIR%\library\web\framework\ewf\libfcgi
echo Install library: ewf/wsf
%COPYCMD% %TMP_DIR%\library\server\wsf	%TMP_CONTRIB_DIR%\library\web\framework\ewf\wsf
echo Install library: ewf/wsf_extension
%COPYCMD% %TMP_DIR%\library\server\wsf_extension	%TMP_CONTRIB_DIR%\library\web\framework\ewf\wsf_extension
echo Install library: ewf/encoder
%COPYCMD% %TMP_DIR%\library\text\encoder	%TMP_CONTRIB_DIR%\library\web\framework\ewf\text\encoder

echo Install examples
%SAFE_MD% %TMP_CONTRIB_DIR%\examples
%SAFE_MD% %TMP_CONTRIB_DIR%\examples\web
%COPYCMD% %TMP_DIR%\examples	%TMP_CONTRIB_DIR%\examples\web\ewf
%COPYCMD% %TMP_DIR%\precomp		%TMP_CONTRIB_DIR%\examples\web\ewf_precomp

echo Install library: error
%COPYCMD% %TMP_DIR%\library\utility\general\error	%TMP_CONTRIB_DIR%\library\utility\general\error
echo Install library: http_client
%COPYCMD% %TMP_DIR%\library\network\http_client	%TMP_CONTRIB_DIR%\library\network\http_client
echo Install library: http
%COPYCMD% %TMP_DIR%\library\network\protocol\http	%TMP_CONTRIB_DIR%\library\network\protocol\http
echo Install library: uri_template
%COPYCMD% %TMP_DIR%\library\text\parser\uri_template %TMP_CONTRIB_DIR%\library\text\parser\uri_template

echo Install contrib library: nino
%COPYCMD% %TMP_DIR%\contrib\library\network\server\nino	%TMP_CONTRIB_DIR%\library\network\server\nino

rem #--- IF Missing ---#

echo Install cURL if missing
%SAFE_MD% %TMP_CONTRIB_DIR%\library\network
if not exist %TMP_CONTRIB_DIR%\library\cURL %COPYCMD% %TMP_DIR%\contrib\ise_library\cURL	%TMP_CONTRIB_DIR%\library\network\cURL
if not exist %TMP_CONTRIB_DIR%\library\cURL\cURL.ecf %SVNCO% https://svn.eiffel.com/eiffelstudio/trunk/Src/library/cURL %TMP_CONTRIB_DIR%\library\network\cURL

echo Install json if missing
if not exist %TMP_CONTRIB_DIR%\library\text\parser\json %COPYCMD% %TMP_DIR%\contrib\library\text\parser\json	%TMP_CONTRIB_DIR%\library\text\parser\json
if not exist %TMP_CONTRIB_DIR%\library\text\parser\json\library\json.ecf %SVNCO% https://svn.github.com/eiffelhub/json.git %TMP_CONTRIB_DIR%\library\text\parser\json

echo Install eapml if missing
if not exist %TMP_CONTRIB_DIR%\library\math\eapml %COPYCMD% %TMP_DIR%\contrib\ise_library\math\eapml	%TMP_CONTRIB_DIR%\library\math\eapml

echo Install eel if missing
if not exist %TMP_CONTRIB_DIR%\library\text\encryption\eel %COPYCMD% %TMP_DIR%\contrib\ise_library\text\encryption\eel	%TMP_CONTRIB_DIR%\library\text\encryption\eel

rem #--- Update ecf files ---#

cd %TMP_TARGET_DIR%

if -%ECF_UPDATER_PATH%- == -- goto use_bin_dir
set TMP_ECF_UPDATER_CMD=%ECF_UPDATER_PATH%\ecf_updater.exe
goto ecf_update

:use_bin_dir
set TMP_ECF_UPDATER_CMD=%~dp0\bin\ecf_updater.bat
goto ecf_update

:ecf_update
call %TMP_ECF_UPDATER_CMD% --force %2 %3 %4 %5 %6 %7 %8 %9 contrib

:end
del %TMP_EXCLUDE%
