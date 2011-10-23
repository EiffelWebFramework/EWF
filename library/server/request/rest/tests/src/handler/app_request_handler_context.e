note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APP_REQUEST_HANDLER_CONTEXT

inherit
	REST_REQUEST_URI_TEMPLATE_HANDLER_CONTEXT

create
	make


feature -- Format

	get_format_id (a_format_variable_name: detachable READABLE_STRING_8; a_content_type_supported: detachable ARRAY [STRING_8])
		do
			if internal_format_id = 0 then
				internal_format_id := request_format_id (a_format_variable_name, a_content_type_supported)
			end
		end

	get_format_name (a_format_variable_name: detachable READABLE_STRING_8; a_content_type_supported: detachable ARRAY [STRING_8])
		do
			if internal_format_name = Void then
				internal_format_name := request_format (a_format_variable_name, a_content_type_supported)
			end
		end

	format_id: INTEGER
		do
			if internal_format_id = 0 then
				get_format_id (Void, Void)
			end
			Result := internal_format_id
		end

	format_name: detachable READABLE_STRING_8
		do
			Result := internal_format_name
			if Result = Void then
				Result := request_format (Void, Void)
				internal_format_name := Result
			end
		end

feature {NONE} -- Internal

	internal_format_id: like format_id

	internal_format_name: like format_name


;note
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
