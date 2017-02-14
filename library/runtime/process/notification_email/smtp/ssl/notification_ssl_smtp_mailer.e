note
	description: "[
			Notification mailer based on STMP protocol.

			Note: it is based on EiffelNet {SMTP_PROTOCOL} implementation, and may not be complete.
		]"
	author: "$Author: jfiat $"
	date: "$Date: 2015-06-30 11:07:17 +0200 (mar., 30 juin 2015) $"
	revision: "$Revision: 97586 $"

class
	NOTIFICATION_SSL_SMTP_MAILER

inherit
	NOTIFICATION_SMTP_MAILER
		redefine
			smtp_protocol
		end

create
	make,
	make_with_user

feature {NONE} -- Initialization

	smtp_protocol: SSL_SMTP_PROTOCOL
			-- SMTP protocol.

invariant
note
	copyright: "2011-2017, Jocelyn Fiat, Javier Velilla, Olivier Ligot, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end

