note
	description: "Summary description for {CHARACTER_ENCODING_VARIANT_RESULTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CHARACTER_ENCODING_VARIANT_RESULTS

feature -- Access

	character_type: detachable STRING

	variant_header: detachable STRING

	supported_variants: detachable LIST [STRING]

	is_acceptable: BOOLEAN

feature -- Change Element

	set_character_type (a_character_type: STRING)
			-- Set `character_type' with `a_character_type'
		do
			character_type := a_character_type
		ensure
			character_type_set: character_type /= Void implies a_character_type = character_type
		end

	set_variant_header
			-- Set variant header as `Accept-Charset'
		do
			variant_header := "Accept-Charset"
		ensure
			variant_header_set: attached variant_header as l_variant_header implies l_variant_header.same_string ("Accept-Charset")
		end

	set_supported_variants (a_supported: LIST [STRING])
			-- Set `supported_variants' with `a_supported'
		do
			supported_variants := a_supported
		ensure
			supported_variants_set: supported_variants /= Void implies supported_variants = a_supported
		end

	set_acceptable (acceptable: BOOLEAN)
			-- Set `is_acceptable' with `acceptabe'
		do
			is_acceptable := acceptable
		ensure
			is_acceptable_set: is_acceptable = acceptable
		end

note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
