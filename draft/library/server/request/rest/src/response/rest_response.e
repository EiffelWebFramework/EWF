note
	description: "Summary description for {REST_RESPONSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REST_RESPONSE

inherit
	WSF_PAGE_RESPONSE
		rename
			header as headers,
			body as message,
			set_body as set_message,
			put_string as append_message,
			make as page_make,
			send_to as send
		end

create
	make

feature {NONE} -- Initialization

	make (a_api: like api)
		do
			api := a_api
			page_make
		end

feature -- Recycle

	recycle
		do
			headers.recycle
			message := Void
		end

feature -- Access

	api: STRING
			-- Associated api query string.

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
