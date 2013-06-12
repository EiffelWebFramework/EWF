note
	description : "[
			Component responsible to send email
			]"
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

deferred class
	NOTIFICATION_MAILER

feature -- Status

	is_available: BOOLEAN
			-- Is mailer available to use?
		deferred
		end

feature -- Basic operation

	process_emails (lst: ITERABLE [NOTIFICATION_EMAIL])
			-- Process set of emails `lst'
		require
			is_available
		do
			across
				lst as c
			loop
				process_email (c.item)
			end
		end

	safe_process_email (a_email: NOTIFICATION_EMAIL)
			-- Same as `process_email', but include the check of `is_available'
		do
			if is_available then
				process_email (a_email)
			end
		end

	process_email (a_email: NOTIFICATION_EMAIL)
			-- Process the sending of `a_email'
		require
			is_available
		deferred
		end

end
