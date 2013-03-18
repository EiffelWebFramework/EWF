note

	description: "[
						Policy that no client ever need use a proxy.

						Users of this policy cannot safely use chunked transfer-encoding, or any
						HTTP/1.1-specific features. So best used only for examples.
						]"
	
	date: "$Date$"
	revision: "$Revision$"

class WSF_NO_PROXY_POLICY

inherit

	WSF_PROXY_USE_POLICY
		redefine
			requires_proxy
		end
	
feature -- Access

	requires_proxy (req: WSF_REQUEST): BOOLEAN
			-- Does `req' require use of `proxy_server'?
		do
		end

	proxy_server (req: WSF_REQUEST): READABLE_STRING_8  -- We can't currently use UT_URI
			-- Absolute URI of proxy server which `req' must use
		do
			Result := "" -- doesn't meet the postcondition, but the precondition is never true.
		end

end
