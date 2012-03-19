note
	description: "Summary description for {WSF_RESPONSE_MESSAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_RESPONSE_MESSAGE

feature {WSF_RESPONSE} -- Output

	send_to (res: WSF_RESPONSE)
		require
			header_not_committed: not res.header_committed
			status_not_committed: not res.status_committed
			no_message_committed: not res.message_committed
		deferred
		ensure
			res_status_set: res.status_is_set
			res_header_committed: res.header_committed
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
