note
	description: "Summary description for {MEDIA_TYPE_VARIANT_RESULTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MEDIA_TYPE_VARIANT_RESULTS

feature

	media_type : detachable STRING
	set_media_type ( a_media_type: STRING)
		do
			media_type := a_media_type
		ensure
			set_media_type : a_media_type ~ media_type
		end

	variant_header : detachable STRING
	set_variant_header
		do
			variant_header := "Accept"
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
