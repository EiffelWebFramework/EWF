note
	description: "Summary description for {WSF_CMS_COMMON_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_COMMON_API

feature {NONE} -- Access

	service: CMS_SERVICE
		deferred
		end

	base_url: detachable READABLE_STRING_8
			-- Base url if any.
		deferred
		end

	based_path (p: STRING): STRING
			-- Path `p' in the context of the `base_url'
		do
			if attached base_url as l_base_url then
				create Result.make_from_string (l_base_url)
				Result.append (p)
			else
				Result := p
			end
		end

feature -- Access

	url_encoded (s: detachable READABLE_STRING_GENERAL): STRING_8
		local
			enc: URL_ENCODER
		do
			create enc
			if s /= Void then
				Result := enc.general_encoded_string (s)
			else
				create Result.make_empty
			end
		end

	html_encoded (s: detachable READABLE_STRING_GENERAL): STRING_8
		local
			enc: HTML_ENCODER
		do
			create enc
			if s /= Void then
				Result := enc.general_encoded_string (s)
			else
				create Result.make_empty
			end
		end

	link (a_text: detachable READABLE_STRING_GENERAL; a_path: STRING; opts: detachable CMS_API_OPTIONS): STRING
		local
			l_html: BOOLEAN
			t: READABLE_STRING_GENERAL
		do
			l_html := True
			if opts /= Void then
				l_html := opts.boolean_item ("html", l_html)
			end
			Result := "<a href=%"" + checked_url (url (a_path, opts)) + "%">"
			if a_text = Void then
				t := a_path
			else
				t := a_text
			end
			if l_html then
				Result.append (html_encoded (t))
			else
				Result.append (checked_plain (t))
			end
			Result.append ("</a>")
		end

	link_with_raw_text (a_text: detachable READABLE_STRING_8; a_path: STRING; opts: detachable CMS_API_OPTIONS): STRING
		local
			l_html: BOOLEAN
			t: READABLE_STRING_8
		do
			l_html := True
			if opts /= Void then
				l_html := opts.boolean_item ("html", l_html)
			end
			Result := "<a href=%"" + checked_url (url (a_path, opts)) + "%">"
			if a_text = Void then
				t := a_path
			else
				t := a_text
			end
			Result.append (t)
			Result.append ("</a>")
		end

	user_link (u: CMS_USER): like link
		do
			Result := link (u.name, "/user/" + u.id.out, Void)
		end

	node_link (n: CMS_NODE): like link
		do
			Result := link (n.title, "/node/" + n.id.out, Void)
		end

	user_url (u: CMS_USER): like url
		do
			Result := url ("/user/" + u.id.out, Void)
		end

	node_url (n: CMS_NODE): like url
		do
			Result := url ("/node/" + n.id.out, Void)
		end

	url (a_path: STRING; opts: detachable CMS_API_OPTIONS): STRING
		local
			q,f: detachable STRING_8
			l_abs: BOOLEAN
		do
			l_abs := False

			Result := based_path (a_path)
			if opts /= Void then
				l_abs := opts.boolean_item ("absolute", l_abs)
				if attached opts.item ("query") as l_query then
					if attached {READABLE_STRING_8} l_query as s_value then
						q := s_value
					elseif attached {ITERABLE [TUPLE [key, value: READABLE_STRING_GENERAL]]} l_query as lst then
						create q.make_empty
						across
							lst as c
						loop
							if q.is_empty then
							else
								q.append_character ('&')
							end
							q.append (url_encoded (c.item.key))
							q.append_character ('=')
							q.append (url_encoded (c.item.value))
						end
					end
				end
				if attached opts.string_item ("fragment") as s_frag then
					f := s_frag
				end
			end
			if q /= Void then
				Result.append ("?" + q)
			end
			if f /= Void then
				Result.append ("#" + f)
			end
			if l_abs then
				Result := based_path (Result)
				if Result.substring_index ("://", 1) = 0 then
					Result.prepend (service.site_url)
				end
			end
		end

	checked_url (a_url: STRING): STRING
		do
			Result := a_url
		end

	checked_plain (a_text: READABLE_STRING_GENERAL): STRING_8
		do
			Result := html_encoder.general_encoded_string (a_text)
		end

feature -- Helper

	is_empty (s: detachable READABLE_STRING_GENERAL): BOOLEAN
			-- Is `s' is Void or empty ?
		do
			Result := s = Void or else s.is_empty
		end

	unix_timestamp (dt: DATE_TIME): INTEGER_64
		do
			Result := (create {HTTP_DATE_TIME_UTILITIES}).unix_time_stamp (dt)
		end

	unix_timestamp_to_date_time (t: INTEGER_64): DATE_TIME
		do
			Result := (create {HTTP_DATE_TIME_UTILITIES}).unix_time_stamp_to_date_time (t)
		end

	string_unix_timestamp_to_date_time (s: READABLE_STRING_8): DATE_TIME
		do
			if s.is_integer_64 then
				Result := (create {HTTP_DATE_TIME_UTILITIES}).unix_time_stamp_to_date_time (s.to_integer_64)
			else
				Result := (create {HTTP_DATE_TIME_UTILITIES}).unix_time_stamp_to_date_time (0)
			end
		end

feature {NONE} -- Implementation

	options_boolean (opts: HASH_TABLE [detachable ANY, STRING]; k: STRING; dft: BOOLEAN): BOOLEAN
		do
			if attached {BOOLEAN} opts.item (k) as h then
				Result := h
			else
				Result := dft
			end
		end

	options_string (opts: HASH_TABLE [detachable ANY, STRING]; k: STRING): detachable STRING
		do
			if attached {STRING} opts.item (k) as s then
				Result := s
			end
		end

	html_encoder: HTML_ENCODER
		once ("thread")
			create Result
		end

end
