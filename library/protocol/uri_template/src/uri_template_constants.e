note
	description: "[
		Summary description for {URI_TEMPLATE_CONSTANTS}.

		see http://tools.ietf.org/html/draft-gregorio-uritemplate-04
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	URI_TEMPLATE_CONSTANTS

feature -- Operator

	Reserved_operator: CHARACTER = '+'

	Form_style_query_operator: CHARACTER = '?'

	Path_style_parameters_operator: CHARACTER = ';'

	Path_segment_operator: CHARACTER = '/'

	Label_operator: CHARACTER = '.'

feature -- Separator	

	Default_delimiter: CHARACTER = '=' --| Draft 0.4  , change to '|' for Draft 0.5

feature -- Explode	

	Explode_plus: CHARACTER = '+'

	Explode_star: CHARACTER = '*'

feature -- Modified	

	Modifier_substring: CHARACTER = ':'

	Modifier_remainder: CHARACTER = '^'

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
