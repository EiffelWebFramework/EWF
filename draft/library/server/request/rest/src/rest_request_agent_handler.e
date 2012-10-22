class
	REST_REQUEST_AGENT_HANDLER [C -> WSF_HANDLER_CONTEXT create make end]

inherit
	WSF_URI_TEMPLATE_AGENT_CONTEXT_HANDLER [C]
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

invariant
note
	copyright: "Copyright (c) 1984-2012, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
