note
	description: "Summary description for {WSF_DECIMAL_VALIDATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_DECIMAL_VALIDATOR

inherit

	WSF_REGEXP_VALIDATOR

create
	make_decimal_validator

feature {NONE} -- Initialization

	make_decimal_validator (e: STRING)
			-- Initialize with specified error message which will be displayed on validation failure
		do
			make_regexp_validator ("^[0-9]+(\.[0-9]*)?$|^\.[0-9]+$", e)
		end

end
