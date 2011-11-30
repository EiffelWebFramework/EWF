note
	description: "Summary description for {LANGUAGE_VARIANT_RESULTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LANGUAGE_VARIANT_RESULTS

feature
	language_type : detachable STRING
	set_language_type ( a_language_type: STRING)
		do
			language_type := a_language_type
		ensure
			set_language_type : a_language_type ~ language_type
		end

	variant_header : detachable STRING
	set_variant_header
		do
			variant_header := "Accept-Language"
		end

	supported_variants : detachable LIST[STRING]
	set_supported_variants (a_supported : LIST[STRING])
		do
			supported_variants := a_supported
		ensure
			set_supported_variants : supported_variants = a_supported
		end

	is_acceptable : BOOLEAN

	set_acceptable  ( acceptable : BOOLEAN)
		do
			is_acceptable := acceptable
		ensure
			is_acceptable = acceptable
		end


note
	copyright: "2011-2011, Javier Velilla, Jocelyn Fiat and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
