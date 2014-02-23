note
	description: "[
		Validator implementation which make sure that the input is a decimal number
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_DECIMAL_VALIDATOR

inherit

	WSF_REGEXP_VALIDATOR
		rename
			make as make_regexp_validator
		end

create
	make

feature {NONE} -- Initialization

	make (e: STRING)
			-- Initialize with specified error message which will be displayed on validation failure
		do
			make_regexp_validator ("^[0-9]+(\.[0-9]*)?$|^\.[0-9]+$", e)
		end

end
