note
	description: "Summary description for {CHARACTER_ENCODING_VARIANT_RESULTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CHARACTER_ENCODING_VARIANT_RESULTS

inherit

	VARIANT_RESULTS
	
feature -- Access

	character_type: detachable READABLE_STRING_8


feature -- Change Element

	set_character_type (a_character_type: READABLE_STRING_8)
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
		end

note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
