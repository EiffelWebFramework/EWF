note
	description: "Summary description for {REST_REQUEST_HANDLER_CONTEXT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	REST_REQUEST_HANDLER_CONTEXT

inherit
	REQUEST_HANDLER_CONTEXT

feature -- Status report

	script_absolute_url (a_path: STRING): STRING
			-- Absolute Url for the script if any, extended by `a_path'
		do
			Result := request.absolute_script_url (a_path)
		end

	script_url (a_path: STRING): STRING
			-- Url relative to script name if any, extended by `a_path'
		require
			a_path_attached: a_path /= Void
		do
			Result := request.script_url (a_path)
		end

	url (args: detachable STRING; abs: BOOLEAN): STRING
			-- Associated url based on `path' and `args'
			-- if `abs' then return absolute url
		local
			s,t: detachable STRING
		do
			s := args
			if s /= Void and then s.count > 0 then
				create t.make_from_string (path)
				if s[1] /= '/' then
					t.append_character ('/')
					t.append (s)
				else
					t.append (s)
				end
				s := t
			else
				s := path
			end
			if abs then
				Result := script_absolute_url (s)
			else
				Result := script_url (s)
			end
		ensure
			result_attached: Result /= Void
		end

	authenticated: BOOLEAN
		do
			if request.http_authorization /= Void then
				Result := True
			end
		end

	authenticated_identifier: detachable READABLE_STRING_32
		do
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
