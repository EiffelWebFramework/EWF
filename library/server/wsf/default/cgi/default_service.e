note
	description: "Summary description for {DEFAULT_SERVICE}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DEFAULT_SERVICE

inherit
	WSF_SERVICE

feature {NONE} -- Initialization

	make_and_launch
		local
			cgi: WGI_CGI_CONNECTOR
		do
			create cgi.make (Current)
			cgi.launch
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
