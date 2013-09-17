note
	description: "Summary description for {MEDIA_TYPE_VARIANT_RESULTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MEDIA_TYPE_VARIANT_RESULTS

inherit

	VARIANT_RESULTS

feature -- Access

	media_type: detachable READABLE_STRING_8

feature -- Change Element

	set_media_type (a_media_type: READABLE_STRING_8)
			-- Set `media_type' as `a_media_type'
		do
			media_type := a_media_type
		ensure
			media_type_set: attached media_type as l_media_type implies l_media_type = a_media_type
		end

	set_variant_header
			-- Set variant header as `Accept'
		do
			variant_header := "Accept"
		end


note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
