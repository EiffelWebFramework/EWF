note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	HELLO_WORLD

inherit
	WGI_RESPONSE_APPLICATION

	DEFAULT_WGI_APPLICATION

create
	make_and_launch

feature -- Response

    response (request: WGI_REQUEST): WGI_RESPONSE
        do
        	if request.path_info.starts_with ("/streaming/") then
        		Result := streaming_response (request)
        	else
	            create Result.make
	            Result.set_status (200)
	            Result.set_header ("Content-Type", "text/html; charset=utf-8")
	            Result.set_message_body ("<html><body>Hello World</body></html>")
        	end
        end

    streaming_response (request: WGI_REQUEST): WGI_RESPONSE
        do
	        create {HELLO_WORLD_RESPONSE} Result.make
            Result.set_status (200)
            Result.set_header ("Content-Type", "text/html; charset=utf-8")
        end
note
	copyright: "2011-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
