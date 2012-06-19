@echo off
setlocal

if "%ECF_UPDATER_PATH%" == "" goto LOCAL_ECF_UPDATER
goto start

:LOCAL_ECF_UPDATER
if exist "%~dp0ecf_updater.exe" set ECF_UPDATER_PATH=%~dp0

if "%ECF_UPDATER_PATH%" == "" goto SEARCH_ECF_UPDATER
goto START

:SEARCH_ECF_UPDATER
for %%f in (ecf_updater.exe) do (
    if exist "%%~dp$PATH:f" set ECF_UPDATER_PATH="%%~dp$PATH:f"
 )
if "%ECF_UPDATER_PATH%" == "" goto BUILD_ECF_UPDATER
echo Using ecf_updater.exe from %ECF_UPDATER_PATH%
goto START

:BUILD_ECF_UPDATER
set TMP_SVN_CHECKOUT=%~dp0.tmp_ecf_updater
call svn checkout https://svn.eiffel.com/eiffelstudio/trunk/Src/tools/ecf_updater %TMP_SVN_CHECKOUT%
call ecb -config %~dp0.tmp_ecf_updater\ecf_updater.ecf -finalize -c_compile -project_path %TMP_SVN_CHECKOUT%
copy %TMP_SVN_CHECKOUT%\EIFGENs\ecf_updater\F_code\ecf_updater.exe %~dp0ecf_updater.exe
rd /q/s %TMP_SVN_CHECKOUT%

set ECF_UPDATER_PATH=%~dp0
goto START

:START
echo Calling %ECF_UPDATER_PATH%ecf_updater.exe %*
call %ECF_UPDATER_PATH%ecf_updater.exe %*
goto END

:END
endlocal
