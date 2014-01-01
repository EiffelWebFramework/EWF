note
	description: "Summary description for {WSF_PHONE_NUMBER_VALIDATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_PHONE_NUMBER_VALIDATOR

inherit

	WSF_REGEXP_VALIDATOR
		rename
			make as make_regexp_validator
		end

create
	make_with_message

feature {NONE} -- Initialization

	make_with_message (e: STRING)
			-- Initialize with specified error message which will be displayed on validation failure
		do
			make_regexp_validator ("", e)
		end

end
