note
	description: "[
				{CHARACTER_ENCODING_VARIANT_RESULTS}
				Represent the character sets results between client preferences and character sets variants supported by the server.
				If the server is unable to supports the requested Accept-Charset values, the server can build
				a response with the list of supported character sets.
			]"

	date: "$Date$"
	revision: "$Revision$"

class
	CHARACTER_ENCODING_VARIANT_RESULTS

inherit

	VARIANT_RESULTS


feature -- Change Element


	set_variant_header
			-- Set variant header as `Accept-Charset'
		do
			variant_header := {HTTP_HEADER_NAMES}.header_accept_charset -- "Accept-Charset"
		end

note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
