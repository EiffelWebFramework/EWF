setlocal
set TMP_EWF_DIR=%1
if -%TMP_EWF_DIR%- == -- goto end

:ewf
	if exist %TMP_EWF_DIR% goto ewf_update
	svn co https://github.com/EiffelWebFramework/EWF/trunk _ewf
	move _ewf %TMP_EWF_DIR%
	rd /q/s %TMP_EWF_DIR%\doc\wiki
	rd /q/s %TMP_EWF_DIR%\contrib\library\server\nino
	rd /q/s %TMP_EWF_DIR%\contrib\library\text\parser\json
	rd /q/s %TMP_EWF_DIR%\contrib\ise_library\cURL
	goto nino
:ewf_update
	svn update %TMP_EWF_DIR%
	goto nino

:nino
	if exist %TMP_EWF_DIR%\contrib\library\server\nino goto nino_update
	svn co https://github.com/EiffelWebFramework/EiffelWebNino/trunk _nino
	move _nino %TMP_EWF_DIR%\contrib\library\server\nino
	goto json
:nino_update
	svn update %TMP_EWF_DIR%\contrib\library\server\nino
	goto json

:json
	if exist %TMP_EWF_DIR%\contrib\library\text\parser\json goto json_update
	svn co https://github.com/EiffelWebFramework/ejson-svn/trunk _json
	move _json %TMP_EWF_DIR%\contrib\library\text\parser\json
	goto curl
:json_update
	svn update %TMP_EWF_DIR%\contrib\library\text\parser\json
	goto curl

:curl
	if exist %TMP_EWF_DIR%\contrib\ise_library\cURL goto curl_update
	svn co https://github.com/EiffelSoftware/mirror-Eiffel-cURL/trunk _curl
	move _curl %TMP_EWF_DIR%\contrib\ise_library\cURL
	goto end
:curl_update
	svn update %TMP_EWF_DIR%\contrib\ise_library\cURL
	goto end

:end
endlocal
