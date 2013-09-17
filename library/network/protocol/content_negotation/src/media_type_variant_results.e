note
	description: "Summary description for {MEDIA_TYPE_VARIANT_RESULTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MEDIA_TYPE_VARIANT_RESULTS

feature -- Access

	media_type: detachable STRING

	variant_header: detachable STRING

	supported_variants: detachable LIST [STRING]

	is_acceptable: BOOLEAN


feature -- Change Element

	set_media_type (a_media_type: STRING)
			-- Set `media_type' as `a_media_type'
		do
			media_type := a_media_type
		ensure
			media_type_set: media_type /= Void implies media_type = a_media_type
		end


	set_variant_header
			-- Set variant header as `Accept'
		do
			variant_header := "Accept"
		ensure
			variant_header_set: attached variant_header as l_variant_header implies l_variant_header.same_string ("Accept")
		end


	set_supported_variants (a_supported: LIST [STRING])
			-- Set `supported_variants' with `a_supported'
		do
			supported_variants := a_supported
		ensure
			supported_variants_variants: supported_variants /= Void implies supported_variants = a_supported
		end


	set_acceptable (acceptable: BOOLEAN)
			-- Set `is_acceptable' with `acceptable'
		do
			is_acceptable := acceptable
		ensure
			is_acceptable_set: is_acceptable = acceptable
		end

note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
