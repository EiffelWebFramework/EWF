note
	description: "Summary description for {APP_WSF_HTTPD_REQUEST_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	APP_WSF_HTTPD_REQUEST_HANDLER

inherit
	WSF_HTTPD_REQUEST_HANDLER

create
	make

feature -- Execute	

	do_more (req: WGI_REQUEST; res: WGI_RESPONSE)
		local
			exec: WSF_EXECUTION
		do
			create {APP_WSF_EXECUTION} exec.make (req, res)
			exec.execute
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
