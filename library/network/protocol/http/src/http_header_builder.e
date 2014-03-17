note
	description: "[
			The class provides an easy way to build HTTP header text
			thanks to add_header (..) and put_header (..)
			
			You will also find some helper features to help coding most common usages
			
			Please, have a look at constants classes such as
				HTTP_MIME_TYPES
				HTTP_HEADER_NAMES
				HTTP_STATUS_CODE
				HTTP_REQUEST_METHODS
			(or HTTP_CONSTANTS which groups them for convenience)
			
			Note the return status code is not part of the HTTP header
		]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	HTTP_HEADER_BUILDER

inherit
	ITERABLE [READABLE_STRING_8]

feature -- Access: deferred

	new_cursor: INDEXABLE_ITERATION_CURSOR [READABLE_STRING_8]
			-- Fresh cursor associated with current structure.
		deferred
		end

feature -- Header change: deferred

	add_header (h: READABLE_STRING_8)
			-- Add header `h'
			-- if it already exists, there will be multiple header with same name
			-- which can also be valid
		require
			h_not_empty: not h.is_empty
		deferred
		end

	put_header (h: READABLE_STRING_8)
			-- Add header `h' or replace existing header of same header name
		require
			h_not_empty: not h.is_empty
		deferred
		end

feature -- Status report

	has, has_header_named (a_name: READABLE_STRING_8): BOOLEAN
			-- Has header item for `n'?
		local
			ic: like new_cursor
		do
			from
				ic := new_cursor
			until
				ic.after or Result
			loop
				Result := has_same_header_name (ic.item, a_name)
				ic.forth
			end
		end

	has_content_length: BOOLEAN
			-- Has header "Content-Length"
		do
			Result := has_header_named ({HTTP_HEADER_NAMES}.header_content_length)
		end

	has_content_type: BOOLEAN
			-- Has header "Content-Type"
		do
			Result := has_header_named ({HTTP_HEADER_NAMES}.header_content_type)
		end

	has_transfer_encoding_chunked: BOOLEAN
			-- Has "Transfer-Encoding: chunked" header
		do
			if has_header_named ({HTTP_HEADER_NAMES}.header_transfer_encoding) then
				Result := attached header_named_value ({HTTP_HEADER_NAMES}.header_transfer_encoding) as v and then v.same_string (str_chunked)
			end
		end

feature -- Access

	header_named_value (a_name: READABLE_STRING_8): detachable STRING_8
			-- First header item found for `a_name' if any
		local
			n: INTEGER
			l_line: READABLE_STRING_8
			ic: like new_cursor
		do
			n := a_name.count

			from
				ic := new_cursor
			until
				ic.after or Result /= Void
			loop
				l_line := ic.item
				if has_same_header_name (l_line, a_name) then
					Result := l_line.substring (n + 2, l_line.count)
					Result.left_adjust
					Result.right_adjust
				end
				ic.forth
			end
		end

feature -- Header change: general

	add_header_key_value (k,v: READABLE_STRING_8)
			-- Add header `k:v'.
			-- If it already exists, there will be multiple header with same name
			-- which can also be valid
		local
			s: STRING_8
		do
			create s.make (k.count + 2 + v.count)
			s.append (k)
			s.append (colon_space)
			s.append (v)
			add_header (s)
		end

	put_header_key_value (k,v: READABLE_STRING_8)
			-- Add header `k:v', or replace existing header of same header name/key
		local
			s: STRING_8
		do
			create s.make (k.count + 2 + v.count)
			s.append (k)
			s.append (colon_space)
			s.append (v)
			put_header (s)
		end

	put_header_key_values (k: READABLE_STRING_8; a_values: ITERABLE [READABLE_STRING_8]; a_separator: detachable READABLE_STRING_8)
			-- Add header `k: a_values', or replace existing header of same header values/key.
			-- Use `comma_space' as default separator if `a_separator' is Void or empty.
		local
			s: STRING_8
			l_separator: READABLE_STRING_8
		do
			if a_separator /= Void and then not a_separator.is_empty then
				l_separator := a_separator
			else
				l_separator := comma_space
			end
			create s.make_empty
			across
				a_values as c
			loop
				if not s.is_empty then
					s.append_string (l_separator)
				end
				s.append (c.item)
			end
			if not s.is_empty then
				put_header_key_value (k, s)
			end
		end

feature -- Content related header

	put_content_type (t: READABLE_STRING_8)
		do
			put_header_key_value ({HTTP_HEADER_NAMES}.header_content_type, t)
		end

	add_content_type (t: READABLE_STRING_8)
			-- same as `put_content_type', but allow multiple definition of "Content-Type"
		do
			add_header_key_value ({HTTP_HEADER_NAMES}.header_content_type, t)
		end

	put_content_type_with_parameters (t: READABLE_STRING_8; a_params: detachable ARRAY [TUPLE [name: READABLE_STRING_8; value: READABLE_STRING_8]])
		local
			s: STRING_8
		do
			if a_params /= Void and then not a_params.is_empty then
				create s.make_from_string (t)
				across
					a_params as p
				loop
					if attached p.item as nv then
						s.append_character (';')
						s.append_character (' ')
						s.append (nv.name)
						s.append_character ('=')
						s.append_character ('%"')
						s.append (nv.value)
						s.append_character ('%"')
					end
				end
				put_header_key_value ({HTTP_HEADER_NAMES}.header_content_type, s)
			else
				put_content_type (t)
			end
		end

	add_content_type_with_parameters (t: READABLE_STRING_8; a_params: detachable ARRAY [TUPLE [name: READABLE_STRING_8; value: READABLE_STRING_8]])
		local
			s: STRING_8
		do
			if a_params /= Void and then not a_params.is_empty then
				create s.make_from_string (t)
				across
					a_params as p
				loop
					if attached p.item as nv then
						s.append_character (';')
						s.append_character (' ')
						s.append (nv.name)
						s.append_character ('=')
						s.append_character ('%"')
						s.append (nv.value)
						s.append_character ('%"')
					end
				end
				add_header_key_value ({HTTP_HEADER_NAMES}.header_content_type, s)
			else
				add_content_type (t)
			end
		end

	put_content_type_with_charset (t: READABLE_STRING_8; c: READABLE_STRING_8)
		do
			put_content_type_with_parameters (t, <<["charset", c]>>)
		end

	add_content_type_with_charset (t: READABLE_STRING_8; c: READABLE_STRING_8)
			-- same as `put_content_type_with_charset', but allow multiple definition of "Content-Type"	
		do
			add_content_type_with_parameters (t, <<["charset", c]>>)
		end

	put_content_type_with_name (t: READABLE_STRING_8; n: READABLE_STRING_8)
		do
			put_content_type_with_parameters (t, <<["name", n]>>)
		end

	add_content_type_with_name (t: READABLE_STRING_8; n: READABLE_STRING_8)
			-- same as `put_content_type_with_name', but allow multiple definition of "Content-Type"	
		do
			add_content_type_with_parameters (t, <<["name", n]>>)
		end

	put_content_length (n: INTEGER)
		do
			put_header_key_value ({HTTP_HEADER_NAMES}.header_content_length, n.out)
		end

	put_content_transfer_encoding (a_mechanism: READABLE_STRING_8)
			-- Put "Content-Transfer-Encoding" header with for instance "binary"
			--|   encoding := "Content-Transfer-Encoding" ":" mechanism
			--|
			--|   mechanism :=     "7bit"  ;  case-insensitive
			--|                  / "quoted-printable"
			--|                  / "base64"
			--|                  / "8bit"
			--|                  / "binary"
			--|                  / x-token
		do
			put_header_key_value ({HTTP_HEADER_NAMES}.header_content_transfer_encoding, a_mechanism)
		end

	put_content_language (a_lang: READABLE_STRING_8)
			-- Put "Content-Language" header of value `a_lang'.
		do
			put_header_key_value ({HTTP_HEADER_NAMES}.header_content_language, a_lang)
		end

	put_content_encoding (a_enc: READABLE_STRING_8)
			-- Put "Content-Encoding" header of value `a_enc'.
		do
			put_header_key_value ({HTTP_HEADER_NAMES}.header_content_encoding, a_enc)
		end

	put_transfer_encoding (a_enc: READABLE_STRING_8)
			-- Put "Transfer-Encoding" header with for instance "chunked"
		do
			put_header_key_value ({HTTP_HEADER_NAMES}.header_transfer_encoding, a_enc)
		end

	put_transfer_encoding_binary
			-- Put "Transfer-Encoding: binary" header
		do
			put_transfer_encoding (str_binary)
		end

	put_transfer_encoding_chunked
			-- Put "Transfer-Encoding: chunked" header
		do
			put_transfer_encoding (str_chunked)
		end

	put_content_disposition (a_type: READABLE_STRING_8; a_params: detachable READABLE_STRING_8)
			-- Put "Content-Disposition" header
			--| See RFC2183
			--|     disposition := "Content-Disposition" ":"
			--|                    disposition-type
			--|                    *(";" disposition-parm)
			--|     disposition-type := "inline"
			--|                       / "attachment"
			--|                       / extension-token
			--|                       ; values are not case-sensitive
			--|     disposition-parm := filename-parm
			--|                       / creation-date-parm
			--|                       / modification-date-parm
			--|                       / read-date-parm
			--|                       / size-parm
			--|                       / parameter
			--|     filename-parm := "filename" "=" value
			--|     creation-date-parm := "creation-date" "=" quoted-date-time
			--|     modification-date-parm := "modification-date" "=" quoted-date-time
			--|     read-date-parm := "read-date" "=" quoted-date-time
			--|     size-parm := "size" "=" 1*DIGIT
			--|     quoted-date-time := quoted-string
			--|                      ; contents MUST be an RFC 822 `date-time'
			--|                      ; numeric timezones (+HHMM or -HHMM) MUST be used
		do
			if a_params /= Void then
				put_header_key_value ({HTTP_HEADER_NAMES}.header_content_disposition, a_type + semi_colon_space + a_params)
			else
				put_header_key_value ({HTTP_HEADER_NAMES}.header_content_disposition, a_type)
			end
		end

feature -- Content-type helpers

	put_content_type_text_css				do put_content_type ({HTTP_MIME_TYPES}.text_css) end
	put_content_type_text_csv				do put_content_type ({HTTP_MIME_TYPES}.text_csv) end
	put_content_type_text_html				do put_content_type ({HTTP_MIME_TYPES}.text_html) end
	put_content_type_text_javascript		do put_content_type ({HTTP_MIME_TYPES}.text_javascript) end
	put_content_type_text_json				do put_content_type ({HTTP_MIME_TYPES}.text_json) end
	put_content_type_text_plain				do put_content_type ({HTTP_MIME_TYPES}.text_plain) end
	put_content_type_text_xml				do put_content_type ({HTTP_MIME_TYPES}.text_xml) end

	put_content_type_application_json		do put_content_type ({HTTP_MIME_TYPES}.application_json) end
	put_content_type_application_javascript	do put_content_type ({HTTP_MIME_TYPES}.application_javascript) end
	put_content_type_application_zip		do put_content_type ({HTTP_MIME_TYPES}.application_zip)	end
	put_content_type_application_pdf		do put_content_type ({HTTP_MIME_TYPES}.application_pdf) end

	put_content_type_image_gif				do put_content_type ({HTTP_MIME_TYPES}.image_gif) end
	put_content_type_image_png				do put_content_type ({HTTP_MIME_TYPES}.image_png) end
	put_content_type_image_jpg				do put_content_type ({HTTP_MIME_TYPES}.image_jpg) end
	put_content_type_image_svg_xml			do put_content_type ({HTTP_MIME_TYPES}.image_svg_xml) end

	put_content_type_message_http			do put_content_type ({HTTP_MIME_TYPES}.message_http) end

	put_content_type_multipart_mixed		do put_content_type ({HTTP_MIME_TYPES}.multipart_mixed) end
	put_content_type_multipart_alternative	do put_content_type ({HTTP_MIME_TYPES}.multipart_alternative) end
	put_content_type_multipart_related		do put_content_type ({HTTP_MIME_TYPES}.multipart_related) end
	put_content_type_multipart_form_data	do put_content_type ({HTTP_MIME_TYPES}.multipart_form_data) end
	put_content_type_multipart_signed		do put_content_type ({HTTP_MIME_TYPES}.multipart_signed) end
	put_content_type_multipart_encrypted	do put_content_type ({HTTP_MIME_TYPES}.multipart_encrypted) end
	put_content_type_application_x_www_form_encoded	do put_content_type ({HTTP_MIME_TYPES}.application_x_www_form_encoded) end

	put_content_type_utf_8_text_plain		do put_content_type_with_charset ({HTTP_MIME_TYPES}.text_plain, "utf-8") end

feature -- Cross-Origin Resource Sharing

	put_access_control_allow_origin (s: READABLE_STRING_8)
			-- Put "Access-Control-Allow-Origin" header.
		do
			put_header_key_value ({HTTP_HEADER_NAMES}.header_access_control_allow_origin, s)
		end

	put_access_control_allow_all_origin
			-- Put "Access-Control-Allow-Origin: *" header.
		do
			put_access_control_allow_origin ("*")
		end

	put_access_control_allow_methods (a_methods: ITERABLE [READABLE_STRING_8])
			-- If `a_methods' is not empty, put `Access-Control-Allow-Methods' header with list `a_methods' of methods
		do
			put_header_key_values ({HTTP_HEADER_NAMES}.header_access_control_allow_methods, a_methods, Void)
		end

	put_access_control_allow_headers (s: READABLE_STRING_8)
			-- Put "Access-Control-Allow-Headers" header.
		do
			put_header_key_value ({HTTP_HEADER_NAMES}.header_access_control_allow_headers, s)
		end

feature -- Method related

	put_allow (a_methods: ITERABLE [READABLE_STRING_8])
			-- If `a_methods' is not empty, put `Allow' header with list `a_methods' of methods
		do
			put_header_key_values ({HTTP_HEADER_NAMES}.header_allow, a_methods, Void)
		end

feature -- Date

	put_date (s: READABLE_STRING_8)
			-- Put "Date: " header
		do
			put_header_key_value ({HTTP_HEADER_NAMES}.header_date, s)
		end

	put_current_date
			-- Put current date time with "Date" header
		do
			put_utc_date (create {DATE_TIME}.make_now_utc)
		end

	put_utc_date (a_utc_date: DATE_TIME)
			-- Put UTC date time `dt' with "Date" header
		do
			put_date (date_to_rfc1123_http_date_format (a_utc_date))
		end

	put_last_modified (a_utc_date: DATE_TIME)
			-- Put UTC date time `dt' with "Date" header
		do
			put_header_key_value ({HTTP_HEADER_NAMES}.header_last_modified, date_to_rfc1123_http_date_format (a_utc_date))
		end

feature -- Authorization

	put_authorization (s: READABLE_STRING_8)
			-- Put authorization `s' with "Authorization" header
		do
			put_header_key_value ({HTTP_HEADER_NAMES}.header_authorization, s)
		end

feature -- Others	

	put_expires (sec: INTEGER)
		do
			put_expires_string (sec.out)
		end

	put_expires_string (s: STRING)
		do
			put_header_key_value ("Expires", s)
		end

	put_expires_date (a_utc_date: DATE_TIME)
		do
			put_header_key_value ("Expires", date_to_rfc1123_http_date_format (a_utc_date))
		end

	put_cache_control (s: READABLE_STRING_8)
			-- `s' could be for instance "no-cache, must-revalidate"
		do
			put_header_key_value ("Cache-Control", s)
		end

	put_pragma (s: READABLE_STRING_8)
		do
			put_header_key_value ("Pragma", s)
		end

	put_pragma_no_cache
		do
			put_pragma ("no-cache")
		end

feature -- Redirection

	put_location (a_location: READABLE_STRING_8)
			-- Tell the client the new location `a_location'
		require
			a_location_valid: not a_location.is_empty
		do
			put_header_key_value ({HTTP_HEADER_NAMES}.header_location, a_location)
		end

	put_refresh (a_location: READABLE_STRING_8; a_timeout_in_seconds: INTEGER)
			-- Tell the client to refresh page with `a_location' after `a_timeout_in_seconds' in seconds
		require
			a_location_valid: not a_location.is_empty
		do
			put_header_key_value ({HTTP_HEADER_NAMES}.header_refresh, a_timeout_in_seconds.out + "; url=" + a_location)
		end

feature -- Cookie

	put_cookie (key, value: READABLE_STRING_8; expiration, path, domain: detachable READABLE_STRING_8; secure, http_only: BOOLEAN)
			-- Set a cookie on the client's machine
			-- with key 'key' and value 'value'.
			-- Note: you should avoid using "localhost" as `domain' for local cookies
			--       since they are not always handled by browser (for instance Chrome)
		require
			make_sense: (key /= Void and value /= Void) and then (not key.is_empty and not value.is_empty)
			domain_without_port_info: domain /= Void implies domain.index_of (':', 1) = 0
		local
			s: STRING
		do
			s := {HTTP_HEADER_NAMES}.header_set_cookie + colon_space + key + "=" + value
			if
				domain /= Void and then not domain.same_string ("localhost")
			then
				s.append ("; Domain=")
				s.append (domain)
			end
			if path /= Void then
				s.append ("; Path=")
				s.append (path)
			end
			if expiration /= Void then
				s.append ("; Expires=")
				s.append (expiration)
			end
			if secure then
				s.append ("; Secure")
			end
			if http_only then
				s.append ("; HttpOnly")
			end
			add_header (s)
		end

	put_cookie_with_expiration_date (key, value: READABLE_STRING_8; expiration: DATE_TIME; path, domain: detachable READABLE_STRING_8; secure, http_only: BOOLEAN)
			-- Set a cookie on the client's machine
			-- with key 'key' and value 'value'.
		require
			make_sense: (key /= Void and value /= Void) and then (not key.is_empty and not value.is_empty)
		do
			put_cookie (key, value, date_to_rfc1123_http_date_format (expiration), path, domain, secure, http_only)
		end


feature -- Access

	date_to_rfc1123_http_date_format (dt: DATE_TIME): STRING_8
			-- String representation of `dt' using the RFC 1123
		local
			d: HTTP_DATE
		do
			create d.make_from_date_time (dt)
			Result := d.string
		end

feature {NONE} -- Implementation

	has_same_header_name (h: READABLE_STRING_8; a_name: READABLE_STRING_8): BOOLEAN
			-- Header line `h' has same name as `a_name' ?
		do
			if h.starts_with (a_name) then
				if h.valid_index (a_name.count + 1) then
					Result := h[a_name.count + 1] = ':'
				end
			end
		end

feature {NONE} -- Constants

	str_binary: STRING = "binary"
	str_chunked: STRING = "chunked"

	colon_space: IMMUTABLE_STRING_8
		once
			create Result.make_from_string (": ")
		end

	semi_colon_space: IMMUTABLE_STRING_8
		once
			create Result.make_from_string ("; ")
		end

	comma_space: IMMUTABLE_STRING_8
		once
			create Result.make_from_string (", ")
		end

note
	copyright: "2011-2014, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
