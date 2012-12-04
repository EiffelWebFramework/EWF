#!/bin/sh

mkdir tmp
ecb -config ewf_ise_wizard-safe.ecf -target custom_wizard -finalize -c_compile -project_path tmp
mkdir -p custom/spec/$ISE_PLATFORM
mv tmp/EIFGENs/custom_wizard/F_code/wizard custom/spec/$ISE_PLATFORM/wizard
rm -rf tmp

WIZ_TARGET=$ISE_EIFFEL/studio/wizards/new_projects/ewf_custom
rm -rf $WIZ_TARGET
mkdir $WIZ_TARGET
cp -r resources $WIZ_TARGET/resources
cp -f custom/resources/* $WIZ_TARGET/resources
cp -r custom/spec $WIZ_TARGET/spec
cp custom/ewf.dsc $WIZ_TARGET/../ewf_custom.dsc
rm -rf custom/spec
