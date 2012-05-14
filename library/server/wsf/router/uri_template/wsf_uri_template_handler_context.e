note
	description: "[
				Context for the handler execution

				The associated context {WSF_URI_TEMPLATE_HANDLER_CONTEXT} add information about the matched map
					- uri_template : the associated URI_TEMPLATE
					- uri_template_match : the matching result providing path variables
					- additional path_parameter (..) and related queries

				In addition to what WSF_HANDLER_CONTEXT already provides, i.e:
				 	- request: WSF_REQUEST -- Associated request
					- path: READABLE_STRING_8	-- Associated path

			]"
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_URI_TEMPLATE_HANDLER_CONTEXT

inherit
	WSF_HANDLER_CONTEXT
		redefine
			item
		end

	WSF_REQUEST_PATH_PARAMETERS_SOURCE

create
	make

feature {NONE} -- Initialization

	make (req: WSF_REQUEST; tpl: URI_TEMPLATE; tpl_res: URI_TEMPLATE_MATCH_RESULT; p: like path)
		do
			request := req
			uri_template := tpl
			uri_template_match := tpl_res
			path := p
		end

feature -- Access

	uri_template: URI_TEMPLATE

	uri_template_match: URI_TEMPLATE_MATCH_RESULT

feature -- Environment

	path_parameters_count: INTEGER
		do
			Result := uri_template_match.path_variables.count
		end

	urlencoded_path_parameters: TABLE_ITERABLE [READABLE_STRING_8, READABLE_STRING_8]
			-- <Precursor>
		do
			Result := uri_template_match.path_variables
		end

	previous_path_parameters_source: detachable WSF_REQUEST_PATH_PARAMETERS_SOURCE

	apply (req: WSF_REQUEST)
			-- <Precursor>
		do
			previous_path_parameters_source := req.path_parameters_source
			req.set_path_parameters_source (Current)
		end

	revert (req: WSF_REQUEST)
			-- <Precursor>
		do
			req.set_path_parameters_source (previous_path_parameters_source)
			previous_path_parameters_source := Void
		end

feature -- Item

	item (a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE
			-- Variable value for parameter or variable `a_name'
			-- See `{WSF_REQUEST}.item(s)'
		do
			Result := path_parameter (a_name) --| Should we handle url-encoded name?
			if Result = Void then
				Result := request.item (a_name)
			end
		end

feature -- Path parameter

	path_parameter (a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE
		local
			n: READABLE_STRING_8
		do
			n := uri_template_match.encoded_name (a_name)
			if attached uri_template_match.path_variable (n) as s then
				create {WSF_STRING} Result.make (n, s)
			end
		end

	is_integer_path_parameter (a_name: READABLE_STRING_GENERAL): BOOLEAN
			-- Is path parameter related to `a_name' an integer value?
		do
			Result := attached string_path_parameter (a_name) as s and then s.is_integer
		end

	integer_path_parameter (a_name: READABLE_STRING_GENERAL): INTEGER
			-- Integer value for path parameter  `a_name' if relevant.
		require
			is_integer_path_parameter: is_integer_path_parameter (a_name)
		do
			Result := integer_from (path_parameter (a_name))
		end

	string_path_parameter (a_name: READABLE_STRING_GENERAL): detachable READABLE_STRING_32
			-- String value for path parameter  `a_name' if relevant.
		do
			Result := string_from (path_parameter (a_name))
		end

	string_array_path_parameter (a_name: READABLE_STRING_GENERAL): detachable ARRAY [READABLE_STRING_32]
			-- Array of string values for path parameter `a_name' if relevant.
		do
			Result := string_array_for (a_name, agent string_path_parameter)
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
