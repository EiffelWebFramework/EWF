note
	description: "[
				{COMPRESSION_VARIANT_RESULTS}
				Represent the compression results between client preferences and ccompression variants supported by the server.
				If the server is unable to supports the requested Accept-Encoding values, the server can build
				a response with the list of supported encodings/compressions
			]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name= Compression", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.3", "protocol=uri"

class
	COMPRESSION_VARIANT_RESULTS

inherit

	VARIANT_RESULTS


feature -- Change Element

	set_variant_header
			-- Set variant_header as `Accept-Encoding'
		do
			variant_header := "Accept-Encoding"
		end

note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
