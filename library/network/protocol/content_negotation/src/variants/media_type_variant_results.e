note
	description: "[
				{MEDIA_TYPE_VARIANT_RESULTS}. 
				Represent the media type results between client preferences and media type variants supported by the server..
				If the server is unable to supports the requested Accept values, the server can build
				a response with the list of supported representations	
				]"
	date: "$Date$"
	revision: "$Revision$"

class
	MEDIA_TYPE_VARIANT_RESULTS

inherit

	VARIANT_RESULTS


feature -- Change Element

	set_variant_header
			-- Set variant header as `Accept'
		do
			variant_header := "Accept"
		end


note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
