note
	description: "Summary description for {HTTP_CLIENT_REQUEST_CONTEXT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HTTP_CLIENT_REQUEST_CONTEXT

create
	make,
	make_with_credentials_required

feature {NONE} -- Initialization

	make
		do
			create headers.make (2)
			create query_parameters.make (5)
			create form_parameters.make (10)
		end

	make_with_credentials_required
		do
			make
			set_credentials_required (True)
		end

feature -- Settings

	credentials_required: BOOLEAN

feature -- Access

	headers: HASH_TABLE [READABLE_STRING_8, READABLE_STRING_8]

	query_parameters: HASH_TABLE [READABLE_STRING_32, READABLE_STRING_8]

	form_parameters: HASH_TABLE [READABLE_STRING_32, READABLE_STRING_8]

	upload_data: detachable READABLE_STRING_8

	upload_filename: detachable READABLE_STRING_8

	proxy: detachable TUPLE [host: READABLE_STRING_8; port: INTEGER]

feature -- Status report

	has_form_data: BOOLEAN
		do
			Result := not form_parameters.is_empty
		end

	has_upload_data: BOOLEAN
		do
			Result := attached upload_data as d and then not d.is_empty
		end

	has_upload_filename: BOOLEAN
		do
			Result := attached upload_filename as fn and then not fn.is_empty
		end

feature -- Element change

	add_query_parameter (k: READABLE_STRING_8; v: READABLE_STRING_32)
		do
			query_parameters.force (v, k)
		end

	add_form_parameter (k: READABLE_STRING_8; v: READABLE_STRING_32)
		do
			form_parameters.force (v, k)
		end

	set_credentials_required (b: BOOLEAN)
		do
			credentials_required := b
		end

	set_upload_data (a_data: like upload_data)
		require
			has_no_upload_data: not has_upload_data
		do
			upload_data := a_data
		end

	set_upload_filename (a_fn: like upload_filename)
		require
			has_no_upload_filename: not has_upload_filename
		do
			upload_filename := a_fn
		end

	set_proxy (a_host: detachable READABLE_STRING_8; a_port: INTEGER)
		do
			if a_host = Void then
				proxy := Void
			else
				proxy := [a_host, a_port]
			end
		end

note
	copyright: "2011-2012, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
