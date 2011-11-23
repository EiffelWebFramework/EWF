note
	description: "Summary description for REST_REQUEST_AGENT_HANDLER."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REST_REQUEST_AGENT_HANDLER [C -> REST_REQUEST_HANDLER_CONTEXT]

inherit
	REQUEST_AGENT_HANDLER [C]
		rename
			execute as execute_application
		end

	REST_REQUEST_HANDLER [C]
		select
			execute
		end

create
	make

feature -- status

	authentication_required (req: WSF_REQUEST): BOOLEAN
		do
			Result := internal_authentication_required
		end

feature -- Element change

	set_authentication_required (b: like authentication_required)
		do
			internal_authentication_required := b
		end

feature {NONE} -- Implementation

	internal_authentication_required: BOOLEAN

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
