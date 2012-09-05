setlocal

rd /q/s tmp
mkdir tmp
ecb -config ewf_ise_wizard-safe.ecf -target wizard -finalize -c_compile -project_path tmp
mkdir spec
mkdir spec\%ISE_PLATFORM%
move tmp\EIFGENs\wizard\F_code\wizard.exe spec\%ISE_PLATFORM%\wizard.exe
rd /q/s tmp

set WIZ_TARGET=%ISE_EIFFEL%\studio\wizards\new_projects\ewf
rd /q/s %WIZ_TARGET%
mkdir %WIZ_TARGET%
xcopy /I /E /Y %~dp0\pixmaps %WIZ_TARGET%\pixmaps
xcopy /I /E /Y %~dp0\resources %WIZ_TARGET%\resources
xcopy /I /E /Y %~dp0\spec %WIZ_TARGET%\spec
copy ewf.dsc %WIZ_TARGET%\..\ewf.dsc

endlocal
