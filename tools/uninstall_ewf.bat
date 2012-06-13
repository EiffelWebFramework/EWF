@echo off
setlocal
set RDCMD= rd /q/s

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
echo Uninstall framework: ewf
%RDCMD% %TMP_TARGET_DIR%\contrib\library\web\framework\ewf

echo Uninstall ewf examples
%RDCMD% %TMP_TARGET_DIR%\examples\ewf

echo Uninstall library: error
%RDCMD% %TMP_TARGET_DIR%\library\utility\general\error
echo Uninstall library: http_client
%RDCMD% %TMP_TARGET_DIR%\library\network\http_client
echo Uninstall library: http
%RDCMD% %TMP_TARGET_DIR%\library\network\protocol\http
echo Uninstall library: uri_template
%RDCMD% %TMP_TARGET_DIR%\library\text\parser\uri_template

echo Uninstall contrib library: nino
%RDCMD% %TMP_TARGET_DIR%\contrib\library\network\server\nino

:end
