note
	description: "Summary description for {WSF_EMAIL_VALIDATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_EMAIL_VALIDATOR

inherit

	WSF_REGEXP_VALIDATOR

create
	make_email_validator

feature {NONE} -- Initialization

	make_email_validator (e: STRING)
			-- Initialize with specified error message which will be displayed on validation failure
		do
			make_regexp_validator ("^[a-zA-Z0-9._%%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$", e)
		end

end