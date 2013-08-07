note

	description: "[
						Policy-driven helpers to implement processing of GET and HEAD requests.
						]"
	date: "$Date$"
	revision: "$Revision$"

class WSF_GET_HELPER

inherit

	WSF_METHOD_HELPER

feature {NONE} -- Implementation

	send_response (req: WSF_REQUEST; res: WSF_RESPONSE; a_handler: WSF_SKELETON_HANDLER; a_header: HTTP_HEADER;
		a_media_type, a_language_type, a_character_type, a_compression_type: detachable READABLE_STRING_8; a_new_resource: BOOLEAN)
			-- Write response to `req' into `res' in accordance with `a_media_type' etc.
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
	
end
