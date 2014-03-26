note
	description: "[
		Validator implementation which make sure that the input has
		the format of an valid email address. This is just a very
		basic implementation that tests if the given input contains a '@'.
		
		This is a simple checker, it does not handle all the cases.
	]"
	EIS: "name=Application Techniques for Checking and Transformation of Names RFC3696", "protocol=URI", "src=http://tools.ietf.org/html/rfc3696#section-3"
	EIS: "name=Email address (wikipedia)", "protocol=URI", "src=http://en.wikipedia.org/wiki/Email_address"
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

note
	copyright: "2011-2014, Yassin Hassan, Severin Munger, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
