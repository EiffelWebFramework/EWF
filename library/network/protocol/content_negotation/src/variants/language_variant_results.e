note
	description: "Summary description for {LANGUAGE_VARIANT_RESULTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LANGUAGE_VARIANT_RESULTS

inherit

	VARIANT_RESULTS

feature -- Access

	language_type: detachable READABLE_STRING_8
			-- language variant for the response

feature -- Change Element


	set_language_type (a_language_type: READABLE_STRING_8)
			-- Set `language_type' with `a_language_type'
		do
			language_type := a_language_type
		ensure
			language_type_set:  attached language_type as l_language_type implies l_language_type = a_language_type
		end

	set_variant_header
			-- Set variant header as 'Accept-Language'
		do
			variant_header := "Accept-Language"
		end


note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
