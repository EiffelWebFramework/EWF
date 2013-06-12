note
	description: "Summary description for {NOTIFICATION_CHAIN_MAILER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NOTIFICATION_CHAIN_MAILER

inherit
	NOTIFICATION_MAILER

create
	make

feature {NONE} -- Initialization

	make (a_mailer: like active)
		do
			active := a_mailer
		end

feature -- Access

	active: NOTIFICATION_MAILER

	next: detachable NOTIFICATION_MAILER

feature -- Status

	is_available: BOOLEAN
		do
			Result := active.is_available
			if not Result and attached next as l_next then
				Result := l_next.is_available
			end
		end

feature -- Change

	set_next (m: like next)
		do
			next := m
		end

feature -- Basic operation

	process_email (a_email: NOTIFICATION_EMAIL)
		do
			if active.is_available then
				active.process_email (a_email)
			end
			if attached next as l_next and then l_next.is_available then
				l_next.process_email (a_email)
			end
		end

end
