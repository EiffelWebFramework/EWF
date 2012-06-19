#!/bin/sh

TMP_CWD=`pwd`
TMP_DIR=$TMP_CWD/..

CLEANDIR() {
	for v in .svn .git EIFGENs; do
		/usr/bin/find "$1" -name "$v" -type d -exec rm -rf {} \;	
	done
}
SVNCO() {
	svn co $1 $2
}
COPYCMD() {
	if [ -d "$1" ]; then
		if [ -d "$2" ]; then
			echo ERROR "$2" already exists
		fi
		if [ ! -d "$2" ]; then
			/bin/cp -rf "$1" "$2"
			CLEANDIR $2
		fi
	fi
}
COPYCMDIFMISSING() {
	if [ ! -d "$1" ]; then
		COPYCMD $2 $3
	fi
}

if [ -z "$1" ]; then
	echo ERROR: please provide as argument the installation directory
	exit
fi

TMP_TARGET_DIR=$1
TMP_CONTRIB_DIR=$TMP_TARGET_DIR/contrib

echo Install framework ewf
mkdir -p $TMP_CONTRIB_DIR/library/web/framework/ewf
echo Install library: ewf/ewsgi
COPYCMD $TMP_DIR/library/server/ewsgi	$TMP_CONTRIB_DIR/library/web/framework/ewf/ewsgi
echo Install library: ewf/libfcgi
COPYCMD $TMP_DIR/library/server/libfcgi	$TMP_CONTRIB_DIR/library/web/framework/ewf/libfcgi
echo Install library: ewf/wsf
COPYCMD $TMP_DIR/library/server/wsf	$TMP_CONTRIB_DIR/library/web/framework/ewf/wsf
echo Install library: ewf/wsf_extension
COPYCMD $TMP_DIR/library/server/wsf_extension	$TMP_CONTRIB_DIR/library/web/framework/ewf/wsf_extension
echo Install library: ewf/encoder
mkdir -p $TMP_CONTRIB_DIR/library/web/framework/ewf/text
COPYCMD $TMP_DIR/library/text/encoder	$TMP_CONTRIB_DIR/library/web/framework/ewf/text/encoder

echo Install examples
mkdir -p $TMP_CONTRIB_DIR/examples
COPYCMD $TMP_DIR/examples	$TMP_CONTRIB_DIR/examples/ewf
COPYCMD $TMP_DIR/precomp	$TMP_CONTRIB_DIR/examples/ewf_precomp

echo Install library: error
mkdir -p $TMP_CONTRIB_DIR/library/utility/general
COPYCMD $TMP_DIR/library/utility/general/error	$TMP_CONTRIB_DIR/library/utility/general/error
echo Install library: http_client
mkdir -p $TMP_CONTRIB_DIR/library/network
COPYCMD $TMP_DIR/library/network/http_client	$TMP_CONTRIB_DIR/library/network/http_client
echo Install library: http
mkdir -p $TMP_CONTRIB_DIR/library/network/protocol
COPYCMD $TMP_DIR/library/network/protocol/http	$TMP_CONTRIB_DIR/library/network/protocol/http
echo Install library: uri_template
mkdir -p $TMP_CONTRIB_DIR/library/text/parser
COPYCMD $TMP_DIR/library/text/parser/uri_template $TMP_CONTRIB_DIR/library/text/parser/uri_template

echo Install contrib library: nino
mkdir -p $TMP_CONTRIB_DIR/library/network/server
COPYCMD $TMP_DIR/contrib/library/network/server/nino	$TMP_CONTRIB_DIR/library/network/server/nino

#--- IF Missing ---#

echo Install cURL if missing
mkdir -p $TMP_CONTRIB_DIR/library/network
COPYCMDIFMISSING $TMP_TARGET_DIR/library/cURL $TMP_DIR/contrib/ise_library/cURL	$TMP_CONTRIB_DIR/library/network/cURL
if [ ! -d "$TMP_CONTRIB_DIR/library/network/cURL/cURL.ecf" ]; then
	SVNCO https://svn.eiffel.com/eiffelstudio/trunk/Src/library/cURL $TMP_CONTRIB_DIR/library/network/cURL
fi

echo Install json if missing
mkdir -p $TMP_CONTRIB_DIR/library/text/parser
COPYCMDIFMISSING $TMP_CONTRIB_DIR/library/text/parser/json $TMP_DIR/contrib/library/text/parser/json	$TMP_CONTRIB_DIR/library/text/parser/json
if [ ! -d "$TMP_CONTRIB_DIR/library/text/parser/json/library/json.ecf" ]; then
	SVNCO https://svn.github.com/eiffelhub/json.git $TMP_CONTRIB_DIR/library/text/parser/json
fi

echo Install eapml if missing
mkdir -p $TMP_CONTRIB_DIR/library/math
COPYCMDIFMISSING $TMP_CONTRIB_DIR/library/math/eapml $TMP_DIR/contrib/ise_library/math/eapml	$TMP_CONTRIB_DIR/library/math/eapml

echo Install eel if missing
mkdir -p $TMP_CONTRIB_DIR/library/text/encryption
COPYCMDIFMISSING $TMP_CONTRIB_DIR/library/text/encryption/eel $TMP_DIR/contrib/ise_library/text/encryption/eel	$TMP_CONTRIB_DIR/library/text/encryption/eel



#--- Update ecf files ---#

cd $TMP_TARGET_DIR
if [ -z "$ECF_UPDATER_PATH" ]; then
	ECF_UPDATER_PATH=$TMP_CWD/bin
fi
$ECF_UPDATER_PATH/ecf_updater --force --verbose --diff $2 $3 $4 $5 $6 $7 $8 $9 contrib


