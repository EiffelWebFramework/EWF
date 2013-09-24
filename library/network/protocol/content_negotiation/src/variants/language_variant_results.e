note
	description: "[
				{LANGUAGE_VARIANT_RESULTS}.
				Represent the language results between client preferences and language variants supported by the server.
				If the server is unable to supports the requested Accept-Language values, the server can build
				a response with the list of supported languages
			]"
	date: "$Date$"
	revision: "$Revision$"

class
	LANGUAGE_VARIANT_RESULTS

inherit

	VARIANT_RESULTS

feature -- Change Element

	set_variant_header
			-- Set variant header as 'Accept-Language'
		do
			variant_header := {HTTP_HEADER_NAMES}.header_accept_language -- "Accept-Language"
		end

note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
