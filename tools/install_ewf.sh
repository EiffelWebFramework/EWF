#!/bin/sh

TMP_CWD=`pwd`
TMP_DIR=$TMP_CWD/..

CLEANDIR() {
	for v in .svn .git EIFGENs; do
		/usr/bin/find "$1" -name "$v" -type d -exec rm -rf {} \;	
	done
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

echo Install framework ewf
mkdir -p $TMP_TARGET_DIR/contrib/library/web/framework/ewf
echo Install library: ewf/ewsgi
COPYCMD $TMP_DIR/library/server/ewsgi	$TMP_TARGET_DIR/contrib/library/web/framework/ewf/ewsgi
echo Install library: ewf/libfcgi
COPYCMD $TMP_DIR/library/server/libfcgi	$TMP_TARGET_DIR/contrib/library/web/framework/ewf/libfcgi
echo Install library: ewf/wsf
COPYCMD $TMP_DIR/library/server/wsf	$TMP_TARGET_DIR/contrib/library/web/framework/ewf/wsf
echo Install library: ewf/wsf_extension
COPYCMD $TMP_DIR/library/server/wsf_extension	$TMP_TARGET_DIR/contrib/library/web/framework/ewf/wsf_extension
echo Install library: ewf/encoder
mkdir -p $TMP_TARGET_DIR/contrib/library/web/framework/ewf/text
COPYCMD $TMP_DIR/library/text/encoder	$TMP_TARGET_DIR/contrib/library/web/framework/ewf/text/encoder

echo Install examples
mkdir -p $TMP_TARGET_DIR/examples
COPYCMD $TMP_DIR/examples	$TMP_TARGET_DIR/examples/ewf
COPYCMD $TMP_DIR/precomp	$TMP_TARGET_DIR/examples/ewf_precomp

echo Install library: error
mkdir -p $TMP_TARGET_DIR/library/utility/general
COPYCMD $TMP_DIR/library/utility/general/error	$TMP_TARGET_DIR/library/utility/general/error
echo Install library: http_client
mkdir -p $TMP_TARGET_DIR/library/network
COPYCMD $TMP_DIR/library/network/http_client	$TMP_TARGET_DIR/library/network/http_client
echo Install library: http
mkdir -p $TMP_TARGET_DIR/library/network/protocol
COPYCMD $TMP_DIR/library/network/protocol/http	$TMP_TARGET_DIR/library/network/protocol/http
echo Install library: uri_template
mkdir -p $TMP_TARGET_DIR/library/text/parser
COPYCMD $TMP_DIR/library/text/parser/uri_template $TMP_TARGET_DIR/library/text/parser/uri_template

echo Install contrib library: nino
mkdir -p $TMP_TARGET_DIR/contrib/library/network/server
COPYCMD $TMP_DIR/contrib/library/network/server/nino	$TMP_TARGET_DIR/contrib/library/network/server/nino

#--- IF Missing ---#

echo Install cURL if missing
mkdir -p $TMP_TARGET_DIR/contrib/library/network
COPYCMDIFMISSING $TMP_TARGET_DIR/library/cURL $TMP_DIR/contrib/ise_library/cURL	$TMP_TARGET_DIR/contrib/library/network/cURL

echo Install eapml if missing
mkdir -p $TMP_TARGET_DIR/contrib/library/math
COPYCMDIFMISSING $TMP_TARGET_DIR/contrib/library/math/eapml $TMP_DIR/contrib/ise_library/math/eapml	$TMP_TARGET_DIR/contrib/library/math/eapml

echo Install eel if missing
mkdir -p $TMP_TARGET_DIR/contrib/library/text/encryption
COPYCMDIFMISSING $TMP_TARGET_DIR/contrib/library/text/encryption/eel $TMP_DIR/contrib/ise_library/text/encryption/eel	$TMP_TARGET_DIR/contrib/library/text/encryption/eel

echo Install json if missing
mkdir -p $TMP_TARGET_DIR/contrib/library/text/parser
COPYCMDIFMISSING $TMP_TARGET_DIR/contrib/library/text/parser/json $TMP_DIR/contrib/library/text/parser/json	$TMP_TARGET_DIR/contrib/library/text/parser/json


#--- Update ecf files ---#

cd $TMP_TARGET_DIR
echo ecf_updater
$TMP_CWD/bin/ecf_updater --force --verbose --diff $2 $3 $4 $5 $6 $7 $8 $9 .


