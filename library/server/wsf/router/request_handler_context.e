note
	description: "Summary description for {REQUEST_HANDLER_CONTEXT}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	REQUEST_HANDLER_CONTEXT

inherit
	ANY

	REQUEST_FORMAT_UTILITY
		export
			{NONE} all
		end

feature -- Access

	request: WSF_REQUEST
			-- Associated request

	path: READABLE_STRING_8
			-- Associated path

feature -- Url Query

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
				if s[1] /= '/' and t[t.count] /= '/' then
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

feature -- Query

	request_accepted_content_type (a_supported_content_types: detachable ARRAY [READABLE_STRING_8]): detachable READABLE_STRING_8
			-- Accepted content-type for the request, among the supported content types `a_supported_content_types'
		local
			s: detachable READABLE_STRING_8
			i,n: INTEGER
		do
			if
				attached accepted_content_types (request) as l_accept_lst and then
				not l_accept_lst.is_empty
			then
				from
					l_accept_lst.start
				until
					l_accept_lst.after or Result /= Void
				loop
					s := l_accept_lst.item
					if a_supported_content_types /= Void then
						from
							i := a_supported_content_types.lower
							n := a_supported_content_types.upper
						until
							i > n or Result /= Void
						loop
							if a_supported_content_types [i].same_string (s) then
								Result := s
							end
							i := i + 1
						end
					else
						Result := s
					end
					l_accept_lst.forth
				end
			end
		end

feature -- Query	

	path_parameter (a_name: READABLE_STRING_8): detachable WSF_VALUE
			-- Parameter value for path variable `a_name'
		deferred
		end

	query_parameter (a_name: READABLE_STRING_8): detachable WSF_VALUE
			-- Parameter value for query variable `a_name'	
			--| i.e after the ? character
		deferred
		end

	parameter (a_name: READABLE_STRING_8): detachable WSF_VALUE
			-- Any parameter value for variable `a_name'
			-- URI template parameter and query parameters
		do
			Result := query_parameter (a_name)
			if Result = Void then
				Result := path_parameter (a_name)
			end
		end

feature -- Convertion

	string_from (a_value: detachable WSF_VALUE): detachable READABLE_STRING_32
			-- String value from `a_value' if relevant.
		do
			if attached {WSF_STRING} a_value as val then
				Result := val.string
			end
		end

	integer_from (a_value: detachable WSF_VALUE): INTEGER
			-- String value from `a_value' if relevant.	
		do
			if attached string_from (a_value) as val then
				if val.is_integer then
					Result := val.to_integer
				end
			end
		end

feature -- Path parameter

	is_integer_path_parameter (a_name: READABLE_STRING_8): BOOLEAN
			-- Is path parameter related to `a_name' an integer value?
		do
			Result := attached string_path_parameter (a_name) as s and then s.is_integer
		end

	integer_path_parameter (a_name: READABLE_STRING_8): INTEGER
			-- Integer value for path parameter  `a_name' if relevant.
		require
			is_integer_path_parameter: is_integer_path_parameter (a_name)
		do
			Result := integer_from (path_parameter (a_name))
		end

	string_path_parameter (a_name: READABLE_STRING_8): detachable READABLE_STRING_32
			-- String value for path parameter  `a_name' if relevant.
		do
			Result := string_from (path_parameter (a_name))
		end

	string_array_path_parameter (a_name: READABLE_STRING_8): detachable ARRAY [READABLE_STRING_32]
			-- Array of string values for path parameter `a_name' if relevant.
		local
			i: INTEGER
			n: INTEGER
		do
			from
				i := 1
				n := 1
				create Result.make_filled ("", 1, 5)
			until
				i = 0
			loop
				if attached string_path_parameter (a_name + "[" + i.out + "]") as v then
					Result.force (v, n)
					n := n + 1
					i := i + 1
				else
					i := 0 -- Exit
				end
			end
			Result.keep_head (n - 1)
		end

feature -- String parameter	

	is_integer_query_parameter (a_name: READABLE_STRING_8): BOOLEAN
			-- Is query parameter related to `a_name' an integer value?
		do
			Result := attached string_query_parameter (a_name) as s and then s.is_integer
		end

	integer_query_parameter (a_name: READABLE_STRING_8): INTEGER
			-- Integer value for query parameter  `a_name' if relevant.
		require
			is_integer_query_parameter: is_integer_query_parameter (a_name)
		do
			Result := integer_from (query_parameter (a_name))
		end

	string_query_parameter (a_name: READABLE_STRING_8): detachable READABLE_STRING_32
			-- String value for query parameter `a_name' if relevant.	
		do
			Result := string_from (query_parameter (a_name))
		end

	string_array_query_parameter (a_name: READABLE_STRING_8): detachable ARRAY [READABLE_STRING_32]
			-- Array of string values for query parameter `a_name' if relevant.
		local
			i: INTEGER
			n: INTEGER
		do
			from
				i := 1
				n := 1
				create Result.make_filled ("", 1, 5)
			until
				i = 0
			loop
				if attached string_query_parameter (a_name + "[" + i.out + "]") as v then
					Result.force (v, n)
					n := n + 1
					i := i + 1
				else
					i := 0 -- Exit
				end
			end
			Result.keep_head (n - 1)
		end

feature -- Parameter

	string_parameter (a_name: READABLE_STRING_8): detachable READABLE_STRING_32
			-- String value for path or query parameter `a_name' if relevant.	
		do
			Result := string_from (parameter (a_name))
		end

;note
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
