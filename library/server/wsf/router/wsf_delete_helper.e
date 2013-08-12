note

	description: "[
						Policy-driven helpers to implement the DELETE method.
					  ]"
	date: "$Date$"
	revision: "$Revision$"

class WSF_DELETE_HELPER

inherit

	WSF_METHOD_HELPER

feature {NONE} -- Implementation
	
	send_response (req: WSF_REQUEST; res: WSF_RESPONSE; a_handler: WSF_SKELETON_HANDLER; a_header: HTTP_HEADER; a_new_resource: BOOLEAN)
			-- Write response to deletion of resource named by `req' into `res'.
			-- Upto four execution variables may be set on `req':
			-- "NEGOTIATED_MEDIA_TYPE"
			-- "NEGOTIATED_LANGUAGE"
			-- "NEGOTIATED_CHARSET"
			-- "NEGOTIATED_ENCODING"
		local
			l_dt: STRING
		do
			a_handler.delete (req)
			if a_handler.includes_response_entity (req) then
				a_handler.ensure_content_available (req)
				a_header.put_content_length (a_handler.content_length (req).as_integer_32)
				-- we don't bother supporting chunked responses for DELETE.
			else
				a_header.put_content_length (0)
			end
			if attached req.request_time as l_time then
				l_dt := (create {HTTP_DATE}.make_from_date_time (l_time)).rfc1123_string
				a_header.put_header_key_value ({HTTP_HEADER_NAMES}.header_date, l_dt)
				generate_cache_headers (req, a_handler, a_header, l_time)
			end
			if a_handler.delete_queued (req) then
				res.set_status_code ({HTTP_STATUS_CODE}.accepted)
				res.put_header_text (a_header.string)
				res.put_string (a_handler.content (req))
			elseif a_handler.deleted (req) then
				if a_handler.includes_response_entity (req) then
					res.set_status_code ({HTTP_STATUS_CODE}.ok)
					res.put_header_text (a_header.string)
					res.put_string (a_handler.content (req))
				else
					res.set_status_code ({HTTP_STATUS_CODE}.no_content)
					res.put_header_text (a_header.string)
				end
			else
				write_error_response (req, res)
			end
		end

end
