note
	description: "Summary description for {COMPRESSION_VARIANT_RESULTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name= Compression", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.3", "protocol=uri"

class
	COMPRESSION_VARIANT_RESULTS

inherit

	VARIANT_RESULTS
	
feature -- Access

	compression_type: detachable READABLE_STRING_8
			-- Compression variant for the response


feature -- Change Element

	set_compression_type (a_compression_type: READABLE_STRING_8)
			-- Set `compression_type' with `a_compression_type'
		do
			compression_type := a_compression_type
		ensure
			compression_type_set: attached compression_type as l_compression_type implies l_compression_type = a_compression_type
		end

	set_variant_header
			-- Set variant_header as `Accept-Encoding'
		do
			variant_header := "Accept-Encoding"
		end

note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
