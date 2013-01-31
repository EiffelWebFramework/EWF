note
	description: "Summary description for {CMS_CSS_SELECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_CSS_SELECTOR

create
	make_from_string

feature {NONE} -- Initialization

	make_from_string (s: READABLE_STRING_8)
		do
			string := s
		end

feature -- Conversion

	string: READABLE_STRING_8

end
