note
	description: "Summary description for {LANGUAGE_VARIANT_RESULTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LANGUAGE_VARIANT_RESULTS

feature -- Access

	language_type: detachable STRING


	variant_header: detachable STRING


	supported_variants: detachable LIST [STRING]


	is_acceptable: BOOLEAN


feature -- Change Element

	set_acceptable (acceptable: BOOLEAN)
			-- Set `is_acceptable' with `acceptable'
		do
			is_acceptable := acceptable
		ensure
			is_acceptable_set: is_acceptable = acceptable
		end

	set_language_type (a_language_type: STRING)
			-- Set `language_type' with `a_language_type'
		do
			language_type := a_language_type
		ensure
			language_type_set: language_type/= Void implies a_language_type = language_type
		end

	set_variant_header
			-- Set variant header as 'Accept-Language'
		do
			variant_header := "Accept-Language"
		ensure
			variant_header_set: attached variant_header as l_variant_header implies l_variant_header.same_string ("Accept-Language")
		end

	set_supported_variants (a_supported: LIST [STRING])
			-- Set `supported vairants' with `a_supported'
		do
			supported_variants := a_supported
		ensure
			set_supported_variants: supported_variants /= Void implies supported_variants = a_supported
		end


note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
