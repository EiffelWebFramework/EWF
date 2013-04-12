note
	description: "A JSON object describing a Proxy configuration."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEB_DRIVER_PROXY
create
	make

feature -- Initialization
	make (a_proxy_type : STRING_32)
		do
			set_proxy_type(a_proxy_type)
		end
feature -- Access

	proxy_type:	STRING_32
		--(Required) The type of proxy being used.
		--Possible values are:
		--		direct - A direct connection -
		--		no proxy in use,
		--		manual - Manual proxy settings configured,
		--      e.g. setting a proxy for HTTP, a proxy for FTP, etc,
		--		pac - Proxy autoconfiguration from a URL),
		--		autodetect (proxy autodetection, probably with WPAD,
		--		system - Use system settings

	proxy_auto_config_url : detachable STRING_32
		--(Required if proxyType == pac, Ignored otherwise)
		-- Specifies the URL to be used for proxy autoconfiguration. Expected format example: http://hostname.com:1234/pacfile

	ftp_proxy : detachable STRING_32
	http_proxy: detachable STRING_32
	ssl_Proxy : detachable STRING_32
		--(Optional, Ignored if proxyType != manual) Specifies the proxies to be used for FTP, HTTP and HTTPS requests respectively.
		--Behaviour is undefined if a request is made, where the proxy for the particular protocol is undefined, if proxyType is manual.
		--Expected format example: hostname.com:1234


feature -- Element Change
	set_proxy_type (a_proxy_type : STRING_32)
		do
			proxy_type := a_proxy_type
		end
end
