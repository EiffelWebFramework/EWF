note
	description : "[
			CMS_MAILER using sendmail as mailtool
			]"
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	CMS_SENDMAIL_MAILER

inherit
	CMS_EXTERNAL_MAILER
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			Precursor
			make ("/usr/sbin/sendmail", <<"-t">>)
			if not is_available then
				make ("/usr/bin/sendmail", <<"-t">>)
			end
			set_stdin_mode (True, "%N.%N%N")
		end


end
