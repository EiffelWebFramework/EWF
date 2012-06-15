#!/bin/sh

TMP_SVN_CHECKOUT=`pwd`/tmp_ecf_updater
svn checkout https://svn.eiffel.com/eiffelstudio/trunk/Src/tools/ecf_updater $TMP_SVN_CHECKOUT

$ISE_EIFFEL/studio/spec/$ISE_PLATFORM/bin/ecb -config $TMP_SVN_CHECKOUT/ecf_updater.ecf -finalize -c_compile -project_path $TMP_SVN_CHECKOUT

ls  "$TMP_SVN_CHECKOUT/EIFGENs/ecf_updater/F_code"
if [ -e "$TMP_SVN_CHECKOUT/EIFGENs/ecf_updater/F_code/ecf_updater" ] ; then
	cp "$TMP_SVN_CHECKOUT/EIFGENs/ecf_updater/F_code/ecf_updater" `pwd`/ecf_updater
	#rm -rf $TMP_SVN_CHECKOUT
	echo ecf_updater is available in `pwd`
fi

