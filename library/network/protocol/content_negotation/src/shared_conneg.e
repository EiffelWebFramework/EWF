note
	description: "Summary description for {SHARED_CONNEG}."
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_CONNEG

feature

	Mime: MIME_PARSE
		once
			create Result
		end

	Common: COMMON_ACCEPT_HEADER_PARSER
			-- Charset and Encoding
		once
			create Result
		end

	Language: LANGUAGE_PARSE
		once
			create Result
		end

note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
