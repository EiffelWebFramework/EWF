note
	description: "[
			The class provides an easy way to build HTTP header.
			
			You will also find some helper feature to help coding most common usage
			
			Please, have a look at constants classes such as
				HTTP_MIME_TYPES
				HTTP_HEADER_NAMES
				HTTP_STATUS_CODE
				HTTP_REQUEST_METHODS
			(or HTTP_CONSTANTS which groups them for convenience)
			
			Note the return status code is not part of the HTTP header
			However you can set the "Status: " header line if you want
		]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	HTTP_HEADER

inherit
	ANY

	HTTP_STATUS_CODE_MESSAGES --| useful for `put_status'
		export
			{NONE} all
		end

create
	make,
	make_with_count

feature {NONE} -- Initialization

	make
			-- Initialize current
		do
			make_with_count (3)
		end

	make_with_count (n: INTEGER)
			-- Make with a capacity of `n' header entries
		do
			create {ARRAYED_LIST [READABLE_STRING_8]} headers.make (n)
		end

feature -- Recycle

	recycle
			-- Recycle current object
		do
			headers.wipe_out
		end

feature -- Access

	headers: LIST [READABLE_STRING_8]
			-- Header's lines

	string: STRING
			-- String representation of the headers
		local
			l_headers: like headers
		do
			create Result.make (32)
			l_headers := headers
			if l_headers.is_empty then
				put_content_type_text_html -- See if this make sense to define a default content-type
			else
				from
					l_headers.start
				until
					l_headers.after
				loop
					append_line_to (l_headers.item, Result)
					l_headers.forth
				end
			end
			append_end_of_line_to (Result)
		end

feature -- Header change: general

	add_header (h: READABLE_STRING_8)
			-- Add header `h'
			-- if it already exists, there will be multiple header with same name
			-- which can also be valid
		require
			h_not_empty: not h.is_empty
		do
			headers.force (h)
		end

	put_header (h: READABLE_STRING_8)
			-- Add header `h' or replace existing header of same header name
		require
			h_not_empty: not h.is_empty
		do
			force_header_by_name (header_name (h), h)
		end

	add_header_key_value (k,v: READABLE_STRING_8)
			-- Add header `k:v', or replace existing header of same header name/key
		do
			add_header (k + colon_space + v)
		end

	put_header_key_value (k,v: READABLE_STRING_8)
			-- Add header `k:v', or replace existing header of same header name/key
		do
			put_header (k + colon_space + v)
		end

feature -- Status related

	put_status (c: INTEGER)
			-- Put "Status: " header
			-- Rarely used
		local
			s: STRING
		do
			create s.make_from_string (c.out)
			if attached http_status_code_message (c) as msg then
				s.append_character (' ')
				s.append (msg)
			end
			put_header_key_value ("Status", s)
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

	put_content_type_with_charset (t: READABLE_STRING_8; c: READABLE_STRING_8)
		do
			put_header_key_value ({HTTP_HEADER_NAMES}.header_content_type, t + "; charset=" + c + "")
		end

	add_content_type_with_charset (t: READABLE_STRING_8; c: READABLE_STRING_8)
			-- same as `put_content_type_with_charset', but allow multiple definition of "Content-Type"	
		do
			add_header_key_value ({HTTP_HEADER_NAMES}.header_content_type, t + "; charset=" + c + "")
		end

	put_content_type_with_name (t: READABLE_STRING_8; n: READABLE_STRING_8)
		do
			put_header_key_value ({HTTP_HEADER_NAMES}.header_content_type, t + "; name=%"" + n + "%"")
		end

	add_content_type_with_name (t: READABLE_STRING_8; n: READABLE_STRING_8)
			-- same as `put_content_type_with_name', but allow multiple definition of "Content-Type"	
		do
			add_header_key_value ({HTTP_HEADER_NAMES}.header_content_type, t + "; name=%"" + n + "%"")
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

	put_transfer_encoding (a_enc: READABLE_STRING_8)
			-- Put "Transfer-Encoding" header with for instance "chunked"
		do
			put_header_key_value ({HTTP_HEADER_NAMES}.header_transfer_encoding, a_enc)
		end

	put_transfer_encoding_chunked
			-- Put "Transfer-Encoding: chunked" header
		do
			put_transfer_encoding ("chunked")
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

	put_utc_date (dt: DATE_TIME)
			-- Put UTC date time `dt' with "Date" header
		do
			put_date (dt.formatted_out ("ddd,[0]dd mmm yyyy [0]hh:[0]mi:[0]ss.ff2") + " GMT")
		end

feature -- Others		

	put_expires (n: INTEGER)
		do
			put_header_key_value ("Expires", n.out)
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

	put_cookie (key, value: READABLE_STRING_8; expiration, path, domain, secure: detachable READABLE_STRING_8)
			-- Set a cookie on the client's machine
			-- with key 'key' and value 'value'.
		require
			make_sense: (key /= Void and value /= Void) and then (not key.is_empty and not value.is_empty)
		local
			s: STRING
		do
			s := {HTTP_HEADER_NAMES}.header_set_cookie + colon_space + key + "=" + value
			if expiration /= Void then
				s.append ("; expires=" + expiration)
			end
			if path /= Void then
				s.append ("; path=" + path)
			end
			if domain /= Void then
				s.append ("; domain=" + domain)
			end
			if secure /= Void then
				s.append ("; secure=" + secure)
			end
			add_header (s)
		end

feature -- Status report

	has_header_named (a_name: READABLE_STRING_8): BOOLEAN
			-- Has header item for `n'?
		local
			c: like headers.new_cursor
			n: INTEGER
			l_line: READABLE_STRING_8
		do
			from
				n := a_name.count
				c := headers.new_cursor
			until
				c.after or Result
			loop
				l_line := c.item
				if l_line.starts_with (a_name) then
					if l_line.valid_index (n + 1) then
						Result := l_line [n + 1] = ':'
					end
				end
				c.forth
			end
		end

	has_content_length: BOOLEAN
			-- Has header "content_length"
		do
			Result := has_header_named ({HTTP_HEADER_NAMES}.header_content_length)
		end

feature {NONE} -- Implementation: Header

	force_header_by_name (n: detachable READABLE_STRING_8; h: READABLE_STRING_8)
			-- Add header `h' or replace existing header of same header name `n'
		require
			h_has_name_n: (n /= Void and attached header_name (h) as hn) implies n.same_string (hn)
		local
			l_headers: like headers
		do
			if n /= Void then
				from
					l_headers := headers
					l_headers.start
				until
					l_headers.after or l_headers.item.starts_with (n)
				loop
					l_headers.forth
				end
				if not l_headers.after then
					l_headers.replace (h)
				else
					add_header (h)
				end
			else
				add_header (h)
			end
		end

	header_name (h: READABLE_STRING_8): detachable READABLE_STRING_8
			-- If any, header's name with colon
			--| ex: for "Foo-bar: something", this will return "Foo-bar:"
		local
			s: detachable STRING_8
			i,n: INTEGER
			c: CHARACTER
		do
			from
				i := 1
				n := h.count
				create s.make (10)
			until
				i > n or c = ':' or s = Void
			loop
				c := h[i]
				inspect c
				when ':' then
					s.extend (c)
				when '-', 'a' .. 'z', 'A' .. 'Z' then
					s.extend (c)
				else
					s := Void
				end
				i := i + 1
			end
			Result := s
		end

feature {NONE} -- Implementation

	append_line_to (s: READABLE_STRING_8; h: like string)
		do
			h.append_string (s)
			append_end_of_line_to (h)
		end

	append_end_of_line_to (h: like string)
		do
			h.append_character ('%R')
			h.append_character ('%N')
		end

feature {NONE} -- Constants

	colon_space: STRING = ": "
	semi_colon_space: STRING = "; "

note
	copyright: "2011-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
