note
	description: "[
		Validator implementation which make sure that the input has
		the format of an valid email address. This is just a very
		basic implementation that tests if the given input contains
		a '@'.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_EMAIL_VALIDATOR

inherit

	WSF_REGEXP_VALIDATOR
		rename
			make as make_regexp_validator
		end

create
	make

feature {NONE} -- Initialization

	make (e: STRING_32)
			-- Initialize with specified error message
		do
			make_regexp_validator ("^.*@.*$", e)
		end

end
