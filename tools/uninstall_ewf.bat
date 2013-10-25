@echo off
setlocal
set RDCMD= rd /q/s


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

echo Uninstall framework: ewf
%RDCMD% %TMP_CONTRIB_DIR%\library\web\framework\ewf

echo Uninstall ewf examples
%RDCMD% %TMP_CONTRIB_DIR%\examples\web\ewf
%RDCMD% %TMP_CONTRIB_DIR%\examples\ewb\ewf_precomp

echo Uninstall library: error
%RDCMD% %TMP_CONTRIB_DIR%\library\utility\general\error
echo Uninstall library: http_client
%RDCMD% %TMP_CONTRIB_DIR%\library\network\http_client
echo Uninstall library: http
%RDCMD% %TMP_CONTRIB_DIR%\library\network\protocol\http
echo Uninstall library: content_negotiation
%RDCMD% %TMP_CONTRIB_DIR%\library\network\protocol\content_negotiation
echo Uninstall library: http_authorization
%RDCMD% %TMP_CONTRIB_DIR%\library\network\authentication\http_authorization
echo Uninstall library: security\openid
%RDCMD% %TMP_CONTRIB_DIR%\library\security\openid
echo Uninstall library: uri_template
%RDCMD% %TMP_CONTRIB_DIR%\library\text\parser\uri_template
echo Uninstall library: runtime\process\notification_email
%RDCMD% %TMP_CONTRIB_DIR%\library\runtime\process\notification_email

echo Uninstall contrib library: nino
%RDCMD% %TMP_CONTRIB_DIR%\library\network\server\nino

:end
