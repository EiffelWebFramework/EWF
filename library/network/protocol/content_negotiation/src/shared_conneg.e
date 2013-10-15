note
	description: "Summary description for {SHARED_CONNEG}."
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_CONNEG

feature

	Mime: HTTP_ACCEPT_MEDIA_TYPE_PARSER
		once
			create Result
		end

	Common: HTTP_ANY_ACCEPT_HEADER_PARSER
			-- Charset and Encoding
		once
			create Result
		end

	Language: HTTP_ACCEPT_LANGUAGE_PARSER
		once
			create Result
		end

note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
