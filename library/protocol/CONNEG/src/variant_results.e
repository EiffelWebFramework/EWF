note
	description: "Summary description for {VARIANT_RESULTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VARIANT_RESULTS

feature -- Mime, Language, Charset and Encoding Results

	mime_result : detachable STRING

	set_mime_result ( a_mime: STRING)
		-- set the mime_result with `a_mime'
		do
			mime_result := a_mime
		ensure
			set_mime_result: a_mime ~ mime_result
		end


	language_result : detachable STRING

	set_language_result (a_language : STRING)
			-- set the language_result with `a_language'
		do
			language_result := a_language
		ensure
			set_language : a_language ~ language_result
		end


	charset_result : detachable STRING

	set_charset_result (a_charset : STRING)
			-- set the charset_result with `a_charset'
		do
			charset_result := a_charset
		ensure
			set_charset : a_charset ~ charset_result
		end


	encoding_result : detachable STRING

	set_encoding_defautl (an_encoding : STRING)
		do
			encoding_result := an_encoding
		ensure
			set_encoding : an_encoding ~ encoding_result
		end


note
	copyright: "2011-2011, Javier Velilla, Jocelyn Fiat and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
