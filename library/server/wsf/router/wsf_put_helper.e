note

	description: "[
						Policy-driven helpers to implement PUT.
					  ]"
	date: "$Date$"
	revision: "$Revision$"

class WSF_PUT_HELPER

inherit

	WSF_METHOD_HELPER
		rename
			send_get_response as do_put
		redefine
			execute_new_resource,
			do_put
		end

feature -- Basic operations

	execute_new_resource (req: WSF_REQUEST; res: WSF_RESPONSE; a_handler: WSF_SKELETON_HANDLER)
			-- Write response to non-existing resource requested by  `req.' into `res'.
			-- Policy routines are available in `a_handler'.
		do
			if a_handler.treat_as_moved_permanently (req) then
				-- TODO 301 Moved permanently response (single location)
			else
				handle_content_negotiation (req, res, a_handler, True)
			end
		end

	
feature {NONE} -- Implementation

	do_put (req: WSF_REQUEST; res: WSF_RESPONSE; a_handler: WSF_SKELETON_HANDLER; a_header: HTTP_HEADER;
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
						if a_new_resource then
							a_handler.create_resource (req, res)
							-- 201 or 500 (add support for this?)
						else
							a_handler.check_conflict (req, res)
							if a_handler.conflict_check_code (req) = 0 then
								a_handler.update_resource (req, res)
								-- 204 or 500 (add support for this?)
								-- TODO: more support, such as includes_response_entity
							end
						end
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
