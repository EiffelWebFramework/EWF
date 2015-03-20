note
	description: "Summary description for {WSF_EXECUTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_EXECUTION

--create
--	make

feature {NONE} -- Initialization

	make (req: WGI_REQUEST; res: WGI_RESPONSE)
		do
			create request.make_from_wgi (req)
			create response.make_from_wgi (res)
		end

	request: WSF_REQUEST

	response: WSF_RESPONSE

feature -- Execution

	execute
		deferred
		ensure
			response.status_is_set
		end

note
	copyright: "2011-2015, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
