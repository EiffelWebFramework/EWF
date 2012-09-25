note
	description: "[
					Context for the handler execution
					It provides information related to the matching handler at runtime, i.e:
						- request: WSF_REQUEST -- Associated request
					- path: READABLE_STRING_8	-- Associated path
				]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_HANDLER_CONTEXT

inherit
	ANY

	WSF_FORMAT_UTILITY
		export
			{NONE} all
		end

	DEBUG_OUTPUT

feature -- Access

	request: WSF_REQUEST
			-- Associated request

	path: READABLE_STRING_8
			-- Associated path

feature -- Request data

	apply (req: WSF_REQUEST)
			-- Apply current data to request `req'
			--| mainly to fill {WSF_REQUEST}.path_parameters
		deferred
		end

	revert (req: WSF_REQUEST)
			-- Revert potential previous `apply' for request `req'
			--| mainly to restore previous {WSF_REQUEST}.path_parameters
		deferred
		end

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

feature -- Item

	item (a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE
			-- Variable value for parameter or variable `a_name'
			-- See `{WSF_REQUEST}.item(s)'
		deferred
		end

feature -- Parameter

	string_item (a_name: READABLE_STRING_GENERAL): detachable READABLE_STRING_32
			-- String value for any variable of parameter `a_name' if relevant.	
		do
			Result := string_from (item (a_name))
		end

	string_array_item (a_name: READABLE_STRING_GENERAL): detachable ARRAY [READABLE_STRING_32]
			-- Array of string values for query parameter `a_name' if relevant.
		do
			Result := string_array_for (a_name, agent string_item)
		end

feature -- Query parameter	

	query_parameter (a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE
			-- Parameter value for query variable `a_name'	
			--| i.e after the ? character
		do
			Result := request.query_parameter (a_name)
		end

	string_query_parameter (a_name: READABLE_STRING_GENERAL): detachable READABLE_STRING_32
			-- String value for query parameter `a_name' if relevant.	
		do
			Result := string_from (query_parameter (a_name))
		end

	string_array_query_parameter (a_name: READABLE_STRING_GENERAL): detachable ARRAY [READABLE_STRING_32]
			-- Array of string values for query parameter `a_name' if relevant.
		do
			Result := string_array_for (a_name, agent string_query_parameter)
		end

	is_integer_query_parameter (a_name: READABLE_STRING_GENERAL): BOOLEAN
			-- Is query parameter related to `a_name' an integer value?
		do
			Result := attached string_query_parameter (a_name) as s and then s.is_integer
		end

	integer_query_parameter (a_name: READABLE_STRING_GENERAL): INTEGER
			-- Integer value for query parameter  `a_name' if relevant.
		require
			is_integer_query_parameter: is_integer_query_parameter (a_name)
		do
			Result := integer_from (query_parameter (a_name))
		end

feature -- Convertion

	string_from (a_value: detachable WSF_VALUE): detachable READABLE_STRING_32
			-- String value from `a_value' if relevant.
		do
			if attached {WSF_STRING} a_value as val then
				Result := val.value
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

feature {NONE} -- Implementation		

	string_array_for (a_name: READABLE_STRING_GENERAL; a_item_fct: FUNCTION [ANY, TUPLE [READABLE_STRING_GENERAL], detachable READABLE_STRING_32]): detachable ARRAY [READABLE_STRING_32]
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
				if attached a_item_fct.item ([a_name + "[" + i.out + "]"]) as v then
					Result.force (v, n)
					n := n + 1
					i := i + 1
				else
					i := 0 -- Exit
				end
			end
			Result.keep_head (n - 1)
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := path
		end

;note
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
