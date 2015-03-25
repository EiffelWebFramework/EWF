note
	description: "Summary description for {WSF_EXECUTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_EXECUTION

inherit
	WGI_EXECUTION
		rename
			request as wgi_request,
			response as wgi_response
		redefine
			make,
			execute,
			clean
		end

--create
--	make

feature {NONE} -- Initialization

	make (req: WGI_REQUEST; res: WGI_RESPONSE)
		do
			Precursor (req, res)
			create request.make_from_wgi (wgi_request)
			create response.make_from_wgi (wgi_response)
			initialize
		end

	initialize
			-- Initialize Current object.
			--| To be redefined if needed.
		do

		end

feature {NONE} -- Access

	request: WSF_REQUEST
			-- Access to request data.
			-- Header, Query, Post, Input data..

	response: WSF_RESPONSE
			-- Access to output stream, back to the client.

feature -- Status report

	message_writable: BOOLEAN
		do
			Result := response.message_writable
		end

feature -- Helpers

	put_character (c: CHARACTER_8)
		require
			message_writable: message_writable
		do
			response.put_character (c)
		end

	put_string (s: READABLE_STRING_8)
		require
			message_writable: message_writable
		do
			response.put_string (s)
		end

	put_error (err: READABLE_STRING_8)
		require
			message_writable: message_writable
		do
			response.put_error (err)
		end

feature -- Execution

	execute
			-- Execute Current `request',
			-- getting data from `request'
			-- and response to client via `response'.
		deferred
		ensure then
			status_is_set: response.status_is_set
		end

feature -- Cleaning

	clean
			-- Precursor
		do
			Precursor
			request.destroy
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
