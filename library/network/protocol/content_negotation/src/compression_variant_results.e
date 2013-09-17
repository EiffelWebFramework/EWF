note
	description: "Summary description for {COMPRESSION_VARIANT_RESULTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name= Compression", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.3", "protocol=uri"

class
	COMPRESSION_VARIANT_RESULTS

feature -- Access

	compression_type: detachable STRING

	variant_header: detachable STRING

	supported_variants: detachable LIST [STRING]

	is_acceptable: BOOLEAN

feature -- Change Element

	set_compression_type (a_compression_type: STRING)
			-- Set `compression_type' with `a_compression_type'
		do
			compression_type := a_compression_type
		ensure
			compression_type_set: compression_type /= Void implies a_compression_type = compression_type
		end

	set_variant_header
			-- Set variant_header as `Accept-Encoding'
		do
			variant_header := "Accept-Encoding"
		ensure
			variant_header_set: attached variant_header as l_variant_header implies l_variant_header.same_string ("Accept-Encoding")
		end

	set_supported_variants (a_supported: LIST [STRING])
			-- Set `supported_variants' with `a_supported'
		do
			supported_variants := a_supported
		ensure
			supported_variants_set: supported_variants /= Void implies supported_variants = a_supported
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
