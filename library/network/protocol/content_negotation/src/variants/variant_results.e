note
	description: "Summary description for {VARIANT_RESULTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	VARIANT_RESULTS

feature -- Access

	variant_header: detachable READABLE_STRING_8
			-- variant header for the response

	supported_variants: detachable LIST [READABLE_STRING_8]
			-- Set of supported variants for the response

	is_acceptable: BOOLEAN
			-- is the current variant accepted?

	accept_headers_set: ARRAY[READABLE_STRING_8]
			-- Set of valid accept headers headers
		note
			EIS:"name=Accept", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1", "protocol=uri"
			EIS:"name=Accept-Charset", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.2", "protocol=uri"
			EIS:"name=Accept-Encoding", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.3", "protocol=uri"
			EIS:"name=Accept-Language", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4", "protocol=uri"
		once
			Result:= <<"Accept","Accept-Language","Accept-Encoding","Accept-Charset">>
			Result.compare_objects
		end

feature -- Status_Report

	is_valid_header (a_header: READABLE_STRING_8): BOOLEAN
			-- is `a_header' a valid accept header?
		do
			Result := accept_headers_set.has (a_header)
		end

feature -- Change Element

	set_acceptable (acceptable: BOOLEAN)
			-- Set `is_acceptable' with `acceptable'
		do
			is_acceptable := acceptable
		ensure
			is_acceptable_set: is_acceptable = acceptable
		end


	set_variant_header
			-- Set variant header
		deferred
		ensure
			is_valid_header_set : attached variant_header as l_header implies is_valid_header (l_header)
		end

	set_supported_variants (a_supported: LIST [READABLE_STRING_8])
			-- Set `supported vairants' with `a_supported'
		do
			supported_variants := a_supported
		ensure
			set_supported_variants: attached supported_variants as l_supported_variants  implies l_supported_variants = a_supported
		end

note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
