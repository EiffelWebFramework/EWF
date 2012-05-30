note
	description: "[
				Handler to process /user/{user}/message/ requests
			]"
	date: "$Date$"
	revision: "$Revision$"

class
	USER_MESSAGE_HANDLER

inherit
	WSF_RESPONSE_HANDLER [WSF_URI_TEMPLATE_HANDLER_CONTEXT]

feature -- Access

	response (ctx: WSF_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST): WSF_RESPONSE_MESSAGE
		do
			if attached {WSF_STRING} ctx.path_parameter ("user") as u then
				if req.is_request_method ("GET") then
					Result := user_message_get (u, ctx, req)
				elseif req.is_request_method ("POST") then
					Result := user_message_response_post (u, ctx, req)
				else
					Result := unsupported_method_response (req)
				end
			else
				Result := missing_argument_response ("Missing parameter 'user'.", req)
			end
		end

	missing_argument_response (m: READABLE_STRING_8; req: WSF_REQUEST): WSF_PAGE_RESPONSE
		do
			create Result.make
			Result.set_status_code ({HTTP_STATUS_CODE}.bad_request)
			Result.put_string (req.request_uri + ": " + m)
		end

	unsupported_method_response (req: WSF_REQUEST): WSF_PAGE_RESPONSE
		do
			create Result.make
			Result.set_status_code ({HTTP_STATUS_CODE}.bad_request)
			Result.put_string (req.request_uri + " only support: GET and POST; " + req.request_method + " is not supported.")
		end


	user_message_get (u: WSF_STRING; ctx: WSF_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST): WSF_HTML_PAGE_RESPONSE
		local
			s: STRING_8
		do
			create Result.make
			s := "<p>No message from user '" + u.html_encoded_string + "'.</p>"
			s.append ("<form action=%""+ req.request_uri +"%" method=%"POST%">")
			s.append ("<textarea name=%"message%" rows=%"10%" cols=%"70%" ></textarea>")
			s.append ("<input type=%"submit%" value=%"Ok%" />")
			s.append ("</form>")
			Result.set_body (s)
		end

	user_message_response_post  (u: WSF_STRING; ctx: WSF_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST): WSF_HTML_PAGE_RESPONSE
		local
			s: STRING_8
		do
			create Result.make
			s := "<p>Message from user '<a href=%"/users/" + u.url_encoded_string + "/%">" + u.html_encoded_string + "</a>'.</p>"
			if attached {WSF_STRING} req.form_parameter ("message") as m and then not m.is_empty then
				s.append ("<textarea>"+ m.string +"</textarea>")
			else
				s.append ("<strong>No or empty message!</strong>")
			end
			Result.set_body (s)
		end

end
