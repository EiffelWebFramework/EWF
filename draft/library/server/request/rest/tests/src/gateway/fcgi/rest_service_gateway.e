deferred class
	REST_SERVICE_GATEWAY

inherit
	WSF_SERVICE

feature -- Access

	build_gateway_and_launch
		local
			libfcgi: WGI_LIBFCGI_CONNECTOR
		do
			create libfcgi.make (to_wgi_service)
			libfcgi.launch
		end

	gateway_name: STRING = "libFCGI"

	exit_with_code (a_code: INTEGER)
		do
			(create {EXCEPTIONS}).die (a_code)
		end


note
	copyright: "Copyright (c) 1984-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
