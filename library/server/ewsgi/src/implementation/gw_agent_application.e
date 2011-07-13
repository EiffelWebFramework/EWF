note
	description: "Summary description for {GW_AGENT_APPLICATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GW_AGENT_APPLICATION

inherit
	GW_APPLICATION_IMP

create
	make

feature {NONE} -- Implementation

	make (a_callback: like callback)
			-- Initialize `Current'.
		do
			callback := a_callback
		end

feature {NONE} -- Implementation

	callback: PROCEDURE [ANY, TUPLE [req: like new_request_context; res: like new_response]]
			-- Procedure called on `execute'

	execute (req: like new_request_context; res: like new_response)
			-- Execute the request
		do
			callback.call ([req, res])
		end

invariant
	callback_attached: callback /= Void

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
