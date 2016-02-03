@echo off
setlocal

if "%ECF_TOOL_PATH%" == "" goto LOCAL_ECF_TOOL
goto start

:LOCAL_ECF_TOOL
if exist "%~dp0ecf_tool.exe" set ECF_TOOL_PATH=%~dp0

if "%ECF_TOOL_PATH%" == "" goto SEARCH_ECF_TOOL
goto START

:SEARCH_ECF_TOOL
:: for %%f in (ecf_tool.exe) do (
::		if exist "%%~dp$PATH:f" set ECF_TOOL_PATH="%%~dp$PATH:f"
:: )
if "%ECF_TOOL_PATH%" == "" goto BUILD_ECF_TOOL
echo Using ecf_tool.exe from %ECF_TOOL_PATH%
goto START

:BUILD_ECF_TOOL
set TMP_SVN_CHECKOUT=%~dp0.tmp_ecf_tool
call svn checkout https://svn.eiffel.com/eiffelstudio/trunk/Src/tools/ecf_tool %TMP_SVN_CHECKOUT%
call ecb -config %~dp0.tmp_ecf_tool\ecf_tool.ecf -finalize -c_compile -project_path %TMP_SVN_CHECKOUT%
copy %TMP_SVN_CHECKOUT%\EIFGENs\ecf_tool\F_code\ecf_tool.exe %~dp0ecf_tool.exe
rd /q/s %TMP_SVN_CHECKOUT%

set ECF_TOOL_PATH=%~dp0
goto START

:START
echo Calling %ECF_TOOL_PATH%ecf_tool.exe %*
call %ECF_TOOL_PATH%ecf_tool.exe %*
goto END

:END
endlocal
