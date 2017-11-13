note
	description: "[
		XSS request, redefine query_parameter and form_parameters filtering the data (using XSS protection)
		before return the value.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_XSS_REQUEST

inherit
	WSF_REQUEST
		redefine
			query_parameter,
			form_parameter
		end

	WSF_REQUEST_EXPORTER

	WSF_XSS_UTILITIES

create
	make_from_request

feature {NONE} -- Creation

	make_from_request (req: WSF_REQUEST)
		do
			make_from_wgi (req.wgi_request)
		end

feature -- Query parameters

	query_parameter (a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE
			-- Query parameter for name `a_name'.
		do
			Result := safe_query_parameter (Current, a_name)
		end

feature -- Form Parameters

	form_parameter (a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE
		do
			Result := safe_form_parameter (Current, a_name)
		end


note
	copyright: "2011-2017, Jocelyn Fiat, Javier Velilla, Olivier Ligot, Colin Adams, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
