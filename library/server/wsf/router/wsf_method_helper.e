note

	description: "[
						Policy-driven helpers to implement a method.
                  This implementation is suitable for GET and HEAD.
					  ]"
	date: "$Date$"
	revision: "$Revision$"

class WSF_METHOD_HELPER

feature -- Access

	resource_exists: BOOLEAN
			-- Does the requested resource (request URI) exist?

feature -- Setting

	set_resource_exists
			-- Set `resource_exists' to `True'.
		do
			resource_exists := True
		ensure
			set: resource_exists
		end

feature -- Basic operations

	execute_new_resource (req: WSF_REQUEST; res: WSF_RESPONSE; a_handler: WSF_SKELETON_HANDLER)
			-- Write response to non-existing resource requested by  `req.' into `res'.
			-- Policy routines are available in `a_handler'.
			-- This default implementation does not apply for PUT requests.
			-- The behaviour for POST requests depends upon a policy.
		require
			req_attached: req /= Void
			res_attached: res /= Void
			a_handler_attached: a_handler /= Void
		local
			l_locs: LIST [URI]
			h: HTTP_HEADER
		do
			if a_handler.resource_previously_existed (req) then
				if a_handler.resource_moved_permanently (req) then
					l_locs := a_handler.previous_location (req)
					-- TODO 301 Moved permanently response
				elseif a_handler.resource_moved_temporarily (req) then
					l_locs := a_handler.previous_location (req)
					-- TODO := 302 Found response
				else
					create h.make
					h.put_content_type_text_plain
					h.put_current_date
					h.put_content_length (0)
					res.set_status_code ({HTTP_STATUS_CODE}.gone)
					res.put_header_text (h.string)
				end
			else
				create h.make
				h.put_content_type_text_plain
				h.put_current_date
				h.put_content_length (0)
				res.set_status_code ({HTTP_STATUS_CODE}.not_found)
				res.put_header_text (h.string)
			end
		end

	execute_existing_resource (req: WSF_REQUEST; res: WSF_RESPONSE; a_handler: WSF_SKELETON_HANDLER)
			-- Write response to existing resource requested by  `req' into `res'.
			-- Policy routines are available in `a_handler'.
		require
			req_attached: req /= Void
			res_attached: res /= Void
			a_handler_attached: a_handler /= Void
			not_if_match_star: attached req.http_if_match as l_if_match implies not l_if_match.same_string ("*")
		local
			l_etags: LIST [READABLE_STRING_8]
			l_failed: BOOLEAN
			l_date: HTTP_DATE
		do
			if attached req.http_if_match as l_if_match then
				-- TODO - also if-range when we add support for range requests
				if not l_if_match.same_string ("*") then
					l_etags := l_if_match.split (',')
					l_failed := not across l_etags as i_etags some a_handler.matching_etag (req, i_etags.item, True) end
				end
			end
			if l_failed then
				handle_precondition_failed (req, res)
			else
				if attached req.http_if_unmodified_since as l_if_unmodified_since then
					if l_if_unmodified_since.is_string_8 then
						create l_date.make_from_string (l_if_unmodified_since.as_string_8)
						if not l_date.has_error then
							if a_handler.modified_since (req, l_date.date_time) then
								handle_precondition_failed (req, res)
								l_failed := True
							end
						end
					end
				end
				if not l_failed then
					if attached req.http_if_none_match as l_if_none_match then
						l_etags := l_if_none_match.split (',')
						l_failed := l_if_none_match.same_string ("*") or
							across l_etags as i_etags some a_handler.matching_etag (req, i_etags.item, False) end
					end
					if l_failed then
						handle_if_none_match_failed (req, res)
					else
						if attached req.http_if_modified_since as l_if_modified_since then
							if l_if_modified_since.is_string_8 then
								create l_date.make_from_string (l_if_modified_since.as_string_8)
								if not l_date.has_error then
									if not a_handler.modified_since (req, l_date.date_time) then
										handle_not_modified (req, res)
										l_failed := True
									end
								end
							end
						end
					end
					if not l_failed then
						handle_content_negotiation (req, res, a_handler, False)
					end	
				end
			end
		end

feature {NONE} -- Implementation
	
	handle_content_negotiation (req: WSF_REQUEST; res: WSF_RESPONSE;
		a_handler: WSF_SKELETON_HANDLER; a_new_resource: BOOLEAN)
			-- Negotiate acceptable content for, then write, response requested by `req' into `res'.
			-- Policy routines are available in `a_handler'.
			-- This default version applies to GET and HEAD.
		require
			req_attached: req /= Void
			res_attached: res /= Void
			a_handler_attached: a_handler /= Void
		local
			l_conneg: CONNEG_SERVER_SIDE
			h: HTTP_HEADER
			l_media: MEDIA_TYPE_VARIANT_RESULTS
			l_lang: LANGUAGE_VARIANT_RESULTS
			l_charset: CHARACTER_ENCODING_VARIANT_RESULTS
			l_encoding: COMPRESSION_VARIANT_RESULTS
			l_mime_types, l_langs, l_charsets, l_encodings: LIST [STRING]
			l_vary_star: BOOLEAN
		do
			create h.make
			l_vary_star := not a_handler.predictable_response (req)
			if l_vary_star then
				h.add_header_key_value ({HTTP_HEADER_NAMES}.header_vary, "*")
			elseif attached a_handler.additional_variant_headers (req) as l_additional then
				across l_additional as i_additional loop
					h.add_header_key_value ({HTTP_HEADER_NAMES}.header_vary, i_additional.item)
				end
			end
			l_conneg := a_handler.conneg (req)
			l_mime_types := a_handler.mime_types_supported (req)
			l_media := l_conneg.media_type_preference (l_mime_types, req.http_accept)
			if not l_vary_star and l_mime_types.count > 1 and attached l_media.variant_header as l_media_variant then
				h.add_header_key_value ({HTTP_HEADER_NAMES}.header_vary, l_media_variant)
			end
			if not l_media.is_acceptable then
				handle_not_accepted ("None of the requested ContentTypes were acceptable", req, res)
			else
				l_langs := a_handler.languages_supported (req)
				l_lang := l_conneg.language_preference (l_langs, req.http_accept_language)
				if not l_vary_star and l_langs.count > 1 and attached l_lang.variant_header as l_lang_variant then
					h.add_header_key_value ({HTTP_HEADER_NAMES}.header_vary, l_lang_variant)
				end
				if not l_lang.is_acceptable then
					handle_not_accepted ("None of the requested languages were acceptable", req, res)
				else
					if attached l_lang.language_type as l_language_type then
						h.put_content_language (l_language_type)
					end
					l_charsets := a_handler.charsets_supported (req)
					l_charset := l_conneg.charset_preference (l_charsets, req.http_accept_charset)
					if not l_vary_star and l_charsets.count > 1 and attached l_charset.variant_header as l_charset_variant then
						h.add_header_key_value ({HTTP_HEADER_NAMES}.header_vary, l_charset_variant)
					end
					if not l_charset.is_acceptable then
						handle_not_accepted ("None of the requested character encodings were acceptable", req, res)
					else
						if attached l_media.media_type as l_media_type and attached l_charset.character_type as l_character_type  then
							h.put_content_type (l_media_type + "; charset=" + l_character_type)
						end
						l_encodings := a_handler.encodings_supported (req)
						l_encoding := l_conneg.encoding_preference (l_encodings, req.http_accept_encoding)
						if not l_vary_star and l_encodings.count > 1 and attached l_encoding.variant_header as l_encoding_variant then
							h.add_header_key_value ({HTTP_HEADER_NAMES}.header_vary, l_encoding_variant)
						end
						if not l_encoding.is_acceptable then
							handle_not_accepted ("None of the requested transfer encodings were acceptable", req, res)
						else
							if attached l_encoding.compression_type as l_compression_type then
								h.put_content_encoding (l_compression_type)
							end
							-- We do not support multiple choices, so
							send_get_response (req, res, a_handler, h,
								l_media.media_type, l_lang.language_type, l_charset.character_type, l_encoding.compression_type, a_new_resource)
						end
					end
				end
			end
		end

	send_get_response (req: WSF_REQUEST; res: WSF_RESPONSE; a_handler: WSF_SKELETON_HANDLER; a_header: HTTP_HEADER;
		a_media_type, a_language_type, a_character_type, a_compression_type: detachable READABLE_STRING_8; a_new_resource: BOOLEAN)
			-- Write response to `req' into `res' in accordance with `a_media_type' etc.
		require
			req_attached: req /= Void
			res_attached: res /= Void
			a_handler_attached: a_handler /= Void
			a_header_attached: a_header /= Void			
			a_media_type_attached: a_media_type /= Void
			a_language_type_attached: a_language_type /= Void
			a_character_type_attached: a_character_type /= Void
			a_compression_type_attached: a_compression_type /= Void
		local
			l_chunked, l_ok: BOOLEAN
			l_dt: STRING
		do
			a_handler.ensure_content_available (req, a_media_type, a_language_type, a_character_type, a_compression_type)
			l_chunked := a_handler.is_chunking (req)
			if l_chunked then
				a_header.put_transfer_encoding_chunked
			else
				a_header.put_content_length (a_handler.content_length (req).as_integer_32)
			end
			if attached req.request_time as l_time then
				l_dt := (create {HTTP_DATE}.make_from_date_time (l_time)).rfc1123_string
				a_header.put_header_key_value ({HTTP_HEADER_NAMES}.header_date, l_dt)
				generate_cache_headers (req, a_handler, a_header, l_time)
			end
			l_ok := a_handler.response_ok (req)
			if l_ok then
				res.set_status_code ({HTTP_STATUS_CODE}.ok)
			else
				-- TODO - req.error_handler.has_error = True
				--handle_internal_server_error (a_handler.last_error (req), req, res)
			end
			if attached a_handler.etag (req, a_media_type, a_language_type, a_character_type, a_compression_type) as l_etag then
				a_header.put_header_key_value ({HTTP_HEADER_NAMES}.header_etag, l_etag)
			end
			res.put_header_text (a_header.string)
			if l_ok then
				if l_chunked then
					send_chunked_response (req, res, a_handler, a_header, a_media_type, a_language_type, a_character_type, a_compression_type)
				else
					res.put_string (a_handler.content (req, a_media_type, a_language_type, a_character_type, a_compression_type))
				end
			end
		end

	send_chunked_response (req: WSF_REQUEST; res: WSF_RESPONSE; a_handler: WSF_SKELETON_HANDLER; a_header: HTTP_HEADER;
		a_media_type, a_language_type, a_character_type, a_compression_type: READABLE_STRING_8)
			-- Write response in chunks to `req' into `res' in accordance with `a_media_type' etc.
		require
			req_attached: req /= Void
			res_attached: res /= Void
			a_handler_attached: a_handler /= Void
			a_media_type_attached: a_media_type /= Void
			a_language_type_attached: a_language_type /= Void
			a_character_type_attached: a_character_type /= Void
			a_compression_type_attached: a_compression_type /= Void			
		local
			l_chunk: TUPLE [a_chunk: READABLE_STRING_8; a_extension: detachable READABLE_STRING_8]
		do
			from
				if a_handler.response_ok (req) then
					l_chunk := a_handler.next_chunk (req, a_media_type, a_language_type, a_character_type, a_compression_type)
					res.put_chunk (l_chunk.a_chunk, l_chunk.a_extension)
				else
					-- TODO - req.error_handler.has_error = True
					-- handle_internal_server_error (a_handler.last_error (req), req, res)
				end
			until
				a_handler.finished (req) or not a_handler.response_ok (req)
			loop
				a_handler.generate_next_chunk (req, a_media_type, a_language_type, a_character_type, a_compression_type)
				if a_handler.response_ok (req) then
					l_chunk := a_handler.next_chunk (req, a_media_type, a_language_type, a_character_type, a_compression_type)
					res.put_chunk (l_chunk.a_chunk, l_chunk.a_extension)
				else
					-- TODO - req.error_handler.has_error = True
					-- handle_internal_server_error (a_handler.last_error (req), req, res)
				end
			end
			if a_handler.finished (req) then
				-- TODO - support for trailers
				res.put_chunk_end
			end
		end
	
	generate_cache_headers (req: WSF_REQUEST; a_handler: WSF_SKELETON_HANDLER; a_header: HTTP_HEADER; a_request_time: DATE_TIME)
			-- Write headers affecting caching for `req' into `a_header'.
		require
			req_attached: req /= Void
			a_handler_attached: a_handler /= Void
			a_header_attached: a_header /= Void
			a_request_time_attached: a_request_time /= Void
		local
			l_age, l_age_1, l_age_2: NATURAL
			l_dur: DATE_TIME_DURATION
			l_dt, l_field_names: STRING
		do
			l_age := a_handler.http_1_0_age (req)
			create l_dur.make (0, 0, 0, 0, 0, l_age.as_integer_32)
			l_dt := (create {HTTP_DATE}.make_from_date_time (a_request_time + l_dur)).rfc1123_string
			a_header.put_header_key_value ({HTTP_HEADER_NAMES}.header_expires, l_dt)
			l_age_1 := a_handler.age (req)
			if l_age_1 /= l_age then
				a_header.add_header_key_value ({HTTP_HEADER_NAMES}.header_cache_control, "max-age=" + l_age_1.out)
			end
			l_age_2 := a_handler.shared_age (req)
			if l_age_2 /= l_age_1 then
				a_header.add_header_key_value ({HTTP_HEADER_NAMES}.header_cache_control, "s-maxage=" + l_age_2.out)
			end
			if a_handler.is_freely_cacheable (req) then
				a_header.add_header_key_value ({HTTP_HEADER_NAMES}.header_cache_control, "public")
			elseif attached a_handler.private_headers (req) as l_fields then
				l_field_names := "="
				if not l_fields.is_empty then
					append_field_name (l_field_names, l_fields)
				end
				a_header.add_header_key_value ({HTTP_HEADER_NAMES}.header_cache_control, "private" + l_field_names)
			end
			if attached a_handler.non_cacheable_headers (req) as l_fields then
				l_field_names := "="
				if not l_fields.is_empty then
					append_field_name (l_field_names, l_fields)
				end
				a_header.add_header_key_value ({HTTP_HEADER_NAMES}.header_cache_control, "no-cache" + l_field_names)
			end
			if not a_handler.is_transformable (req) then
				a_header.add_header_key_value ({HTTP_HEADER_NAMES}.header_cache_control, "no-transform")
			end
			if a_handler.must_revalidate (req) then
				a_header.add_header_key_value ({HTTP_HEADER_NAMES}.header_cache_control, "must-revalidate")
			end
			if a_handler.must_proxy_revalidate (req) then
				a_header.add_header_key_value ({HTTP_HEADER_NAMES}.header_cache_control, "proxy-revalidate")
			end			
		end

	append_field_name (a_field_names: STRING; a_fields: LIST [READABLE_STRING_8])
			-- Append all of `a_fields' as a comma-separated list to `a_field_names'.
		require
			a_field_names_attached: a_field_names /= Void
			a_fields_attached: a_fields /= Void
		do
			across a_fields as i_fields loop
				a_field_names.append_string (i_fields.item)
				if not i_fields.is_last then
					a_field_names.append_character (',')
				end
			end
		end

feature -- Basic operations

	handle_not_accepted (a_message: READABLE_STRING_8; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Write a Not Accepted response to `res'.
		require
			req_attached: req /= Void
			res_attached: res /= Void
			a_message_attached: a_message /= Void
		do
			-- TODO: flag this if it gets to code review.
		end

	handle_if_none_match_failed (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Write a Precondition Failed response to `res'.
		require
			req_attached: req /= Void
			res_attached: res /= Void
		do
			-- TODO: flag this if it gets to code review. Why not just handle_precondition_failed?
		end

	handle_not_modified (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Write a Precondition Failed response to `res'.
		require
			req_attached: req /= Void
			res_attached: res /= Void
		do
			-- TODO: flag this if it gets to code review. Why not just handle_precondition_failed?
		end

	handle_precondition_failed  (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Write a precondition failed response for `req' to `res'.
		require
			req_attached: req /= Void
			res_attached: res /= Void
		local
			h: HTTP_HEADER
		do
			create h.make
			h.put_content_type_text_plain
			h.put_current_date
			h.put_content_length (0)
			res.set_status_code ({HTTP_STATUS_CODE}.precondition_failed)
			res.put_header_text (h.string)
		end

note
	copyright: "2011-2013, Jocelyn Fiat, Javier Velilla, Olivier Ligot, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
