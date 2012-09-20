setlocal

rd /q/s tmp
mkdir tmp
ecb -config ewf_ise_wizard-safe.ecf -target custom_wizard -finalize -c_compile -project_path tmp
mkdir custom
mkdir custom\spec
mkdir custom\spec\%ISE_PLATFORM%
move tmp\EIFGENs\custom_wizard\F_code\wizard.exe custom\spec\%ISE_PLATFORM%\wizard.exe
rd /q/s tmp

set WIZ_TARGET=%ISE_EIFFEL%\studio\wizards\new_projects\ewf_custom
rd /q/s %WIZ_TARGET%
mkdir %WIZ_TARGET%
xcopy /I /E /Y %~dp0\pixmaps %WIZ_TARGET%\pixmaps
xcopy /I /E /Y %~dp0\resources %WIZ_TARGET%\resources
copy %~dp0\custom\resources\* %WIZ_TARGET%\resources
xcopy /I /E /Y %~dp0\custom\spec %WIZ_TARGET%\spec
copy %~dp0custom\ewf.dsc %WIZ_TARGET%\..\ewf_custom.dsc

endlocal
