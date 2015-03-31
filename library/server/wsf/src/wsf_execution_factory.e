note
	description: "Summary description for {WSF_EXECUTION_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_EXECUTION_FACTORY

inherit
	WGI_EXECUTION_FACTORY
		redefine
			execution
		end

feature -- Factory

	execution (req: WGI_REQUEST; res: WGI_RESPONSE): WSF_EXECUTION
		deferred
		end

note
	copyright: "2011-2015, Jocelyn Fiat, Javier Velilla, Olivier Ligot, Colin Adams, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
