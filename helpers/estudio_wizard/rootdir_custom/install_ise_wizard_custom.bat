setlocal

set TMP_ROOTDIR=%~dp0rootdir
set TMP_TARGETNAME=custom_wizard

set WIZ_TARGET=%ISE_EIFFEL%\studio\wizards\new_projects\ewf
rd /q/s %WIZ_TARGET%
mkdir %WIZ_TARGET%
xcopy /I /E /Y %TMP_ROOTDIR% %WIZ_TARGET%
copy %~dp0rootdir_custom\ewf.dsc %WIZ_TARGET%\ewf.dsc
copy %~dp0rootdir_custom\resources\* %WIZ_TARGET%\resources
if not exist %WIZ_TARGET%\pixmaps mkdir %WIZ_TARGET%\pixmaps
move %WIZ_TARGET%\ewf.dsc %WIZ_TARGET%\..\ewf.dsc

rd /q/s tmp
mkdir tmp
ecb -config ewf_ise_wizard-safe.ecf -target %TMP_TARGETNAME% -finalize -c_compile -project_path tmp
rd /q/s %WIZ_TARGET%\spec
mkdir %WIZ_TARGET%\spec
mkdir %WIZ_TARGET%\spec\%ISE_PLATFORM%
move tmp\EIFGENs\%TMP_TARGETNAME%\F_code\wizard.exe %WIZ_TARGET%\spec\%ISE_PLATFORM%\wizard.exe
rd /q/s tmp

endlocal
