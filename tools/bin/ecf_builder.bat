@echo off
setlocal

set ECF_BUILDER_PATH=
if exist "%~dp0ecf_builder.exe" set ECF_BUILDER_PATH=%~dp0

if "%ECF_BUILDER_PATH%" == "" goto SEARCH_ECF_BUILDER
goto START

:SEARCH_ECF_BUILDER
rem for %%f in (ecf_builder.exe) do (
rem     if exist "%%~dp$PATH:f" set ECF_BUILDER_PATH="%%~dp$PATH:f"
rem  )
if "%ECF_BUILDER_PATH%" == "" goto BUILD_ECF_BUILDER
echo Using ecf_builder.exe from %ECF_BUILDER_PATH%
goto START

:BUILD_ECF_BUILDER
set TMP_SVN_CHECKOUT=%~dp0.tmp_ecf_builder
call svn checkout https://svn.eiffel.com/eiffelstudio/trunk/Src/tools/ecf_builder %TMP_SVN_CHECKOUT%
call ecb -config %~dp0.tmp_ecf_builder\ecf_builder.ecf -finalize -c_compile -project_path %TMP_SVN_CHECKOUT%
copy %TMP_SVN_CHECKOUT%\EIFGENs\ecf_builder\F_code\ecf_builder.exe %~dp0ecf_builder.exe
rd /q/s %TMP_SVN_CHECKOUT%

set ECF_BUILDER_PATH=%~dp0
goto START

:START
echo Calling %ECF_BUILDER_PATH%ecf_builder.exe %*
call %ECF_BUILDER_PATH%ecf_builder.exe %*
goto END

:END
endlocal
