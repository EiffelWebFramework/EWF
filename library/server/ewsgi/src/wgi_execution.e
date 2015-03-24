note
	description: "Summary description for {WGI_EXECUTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WGI_EXECUTION

--create
--	make

feature {NONE} -- Initialization

	make (req: WGI_REQUEST; res: WGI_RESPONSE)
		do
			request := req
			response := res
		end

feature {NONE} -- Access

	request: WGI_REQUEST

	response: WGI_RESPONSE

feature -- Execution

	execute
			-- Execute the request based on `request' and `response'.
		deferred
		ensure
			status_is_set: response.status_is_set
		end

feature -- Cleaning

	clean
			-- Clean request data.
		do
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
