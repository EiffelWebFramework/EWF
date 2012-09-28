note
	description: "Summary description for EWF_URI_TEMPLATE_WITH_CONTEXT_HANDLER."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_URI_TEMPLATE_CONTEXT_HANDLER [C -> WSF_HANDLER_CONTEXT create make end]

inherit
	WSF_CONTEXT_HANDLER [C]

feature {WSF_ROUTER} -- Mapping

	new_mapping (a_tpl: READABLE_STRING_8): WSF_URI_TEMPLATE_CONTEXT_MAPPING [C]
		do
			create Result.make (a_tpl, Current)
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
