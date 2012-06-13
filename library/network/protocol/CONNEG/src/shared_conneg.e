note
	description: "Summary description for {SHARED_MIME}."
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_CONNEG

feature

	mime: MIME_PARSE
		once
			create Result
		end

	common: COMMON_ACCEPT_HEADER_PARSER
		-- Charset and Encoding
		once
			create Result
		end

	language: LANGUAGE_PARSE
		once
			create Result
		end

note
	copyright: "2011-2011, Javier Velilla, Jocelyn Fiat and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
