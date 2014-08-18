note
	description: "[
		Abstract notion of a URI Template Handler.
		]"
	glossary: "[
		URL Template: A URL Template is a way to specify a URL that includes parameters that 
			must be substituted before the URL is resolved. The syntax is usually to enclose 
			the parameter in Braces ({example}).
		]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_URI_TEMPLATE_HANDLER

inherit
	WSF_HANDLER

	WSF_ROUTER_MAPPING_FACTORY

feature -- Execution

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute `req' responding in `res'.
		require
			req_attached: req /= Void
			res_attached: res /= Void
		deferred
		end

feature {WSF_ROUTER} -- Mapping

	new_mapping (a_tpl: READABLE_STRING_8): WSF_ROUTER_MAPPING
		do
			create {WSF_URI_TEMPLATE_MAPPING} Result.make (a_tpl, Current)
		end

note
	copyright: "2011-2014, Jocelyn Fiat, Javier Velilla, Olivier Ligot, Colin Adams, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
