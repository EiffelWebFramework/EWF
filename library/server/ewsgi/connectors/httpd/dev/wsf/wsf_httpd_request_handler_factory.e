note
	description: "Summary description for {WSF_HTTPD_REQUEST_HANDLER_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_HTTPD_REQUEST_HANDLER_FACTORY [G -> WSF_EXECUTION create make end]

inherit
	HTTPD_REQUEST_HANDLER_FACTORY

feature -- Factory

	new_handler: separate WSF_HTTPD_REQUEST_HANDLER [G]
		do
			create Result.make
		end

note
	copyright: "2011-2015, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
