note

	description: "[
						Policy-driven helpers to implement POST.
					  ]"
	date: "$Date$"
	revision: "$Revision$"

class WSF_POST_HELPER

inherit

	WSF_METHOD_HELPER
		rename
			send_get_response as do_post
		redefine
			execute_new_resource,
			do_post
		end

feature -- Basic operations

	execute_new_resource (req: WSF_REQUEST; res: WSF_RESPONSE; a_handler: WSF_SKELETON_HANDLER)
			-- Write response to non-existing resource requested by  `req.' into `res'.
			-- Policy routines are available in `a_handler'.
		local
			l_etags: LIST [READABLE_STRING_32]
			l_failed: BOOLEAN
		do
			if a_handler.allow_post_to_missing_resource (req) then
				handle_content_negotiation (req, res, a_handler, True)
			else
				-- TODO 404 Not Found
			end
		end

	
feature {NONE} -- Implementation

	do_post (req: WSF_REQUEST; res: WSF_RESPONSE; a_handler: WSF_SKELETON_HANDLER; a_header: HTTP_HEADER;
		a_media_type, a_language_type, a_character_type, a_compression_type: detachable READABLE_STRING_8; a_new_resource: BOOLEAN)
			-- Write response to `req' into `res' in accordance with `a_media_type' etc. as a new URI.
		do
			a_handler.read_entity (req)
			if a_handler.is_entity_too_large (req) then
				handle_request_entity_too_large (req, res, a_handler)
			else
				a_handler.check_content_headers (req)
				if a_handler.content_check_code (req) /= 0 then
					-- TODO - 415 or 501
				else
					a_handler.check_request (req, res)
					if a_handler.request_check_code (req) = 0 then
						a_handler.append_resource (req, res)
						-- 200 or 204 or 303 or 500 (add support for this?)
						-- TODO: more support, such as includes_response_entity
					end
				end
			end
		end

	handle_request_entity_too_large (req: WSF_REQUEST; res: WSF_RESPONSE; a_handler: WSF_SKELETON_HANDLER)
			-- TODO.
		require
			-- TODO
		do
			-- Need to check if condition is temporary.
		end
	
end
