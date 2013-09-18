note
	description: "Summary description for {WSF_PHONE_NUMBER_VALIDATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_PHONE_NUMBER_VALIDATOR

inherit

	WSF_REGEXP_VALIDATOR

create
	make_with_message

feature {NONE}

	make_with_message (e: STRING)
		do
			make_regexp_validator ("", e)
		end

end
