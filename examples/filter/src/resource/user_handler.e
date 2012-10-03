note
	description: "User handler."
	author: "Olivier Ligot"
	date: "$Date$"
	revision: "$Revision$"

class
	USER_HANDLER

inherit
	WSF_FILTER_CONTEXT_HANDLER

	WSF_URI_TEMPLATE_CONTEXT_HANDLER
		redefine
			new_mapping
		end

	WSF_RESOURCE_CONTEXT_HANDLER_HELPER
		redefine
			do_get,
			context_anchor
		end

	SHARED_DATABASE_API

	SHARED_EJSON

feature -- Basic operations

	execute (ctx: attached like context_anchor; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler	
		do
			execute_methods (ctx, req, res)
			execute_next (ctx, req, res)
		end

	do_get (ctx: attached like context_anchor; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Using GET to retrieve resource information.
			-- If the GET request is SUCCESS, we response with
			-- 200 OK, and a representation of the user
			-- If the GET request is not SUCCESS, we response with
			-- 404 Resource not found
		require else
			authenticated_user_attached: attached ctx.user
		local
			id :  STRING
		do
			if attached req.orig_path_info as orig_path then
				id := get_user_id_from_path (orig_path)
				if attached retrieve_user (id) as l_user then
					if l_user ~ ctx.user then
						compute_response_get (req, res, l_user)
					elseif attached ctx.user as l_auth_user then
						-- Trying to access another user that the authenticated one,
						-- which is forbidden in this example...
						handle_forbidden ("You try to access the user " + id.out + " while authenticating with the user " + l_auth_user.id.out, req, res)
					end
				else
					handle_resource_not_found_response ("The following resource " + orig_path + " is not found ", req, res)
				end
			end
		end

feature {WSF_ROUTER} -- Mapping

	new_mapping (a_tpl: READABLE_STRING_8): FILTER_CONTEXT_MAPPING
		do
			create Result.make (a_tpl, Current)
		end

feature {NONE} -- Implementation

	context_anchor: detachable FILTER_HANDLER_CONTEXT do end

	compute_response_get (req: WSF_REQUEST; res: WSF_RESPONSE; l_user : USER)
		local
			h: HTTP_HEADER
			l_msg : STRING
		do
			create h.make
			h.put_content_type_application_json
			if attached {JSON_VALUE} json.value (l_user) as jv then
				l_msg := jv.representation
				h.put_content_length (l_msg.count)
				if attached req.request_time as time then
					h.add_header ("Date:" + time.formatted_out ("ddd,[0]dd mmm yyyy [0]hh:[0]mi:[0]ss.ff2") + " GMT")
				end
				res.set_status_code ({HTTP_STATUS_CODE}.ok)
				res.put_header_text (h.string)
				res.put_string (l_msg)
			end
		end

	get_user_id_from_path (a_path: READABLE_STRING_32) : STRING
		do
			Result := a_path.split ('/').at (3)
		end

	retrieve_user (id: STRING) : detachable USER
			-- Retrieve the user by id if it exist, in other case, Void
		do
			if id.is_integer and then Db_access.users.has (id.to_integer) then
				Result := db_access.users.item (id.to_integer)
			end
		end

note
	copyright: "2011-2012, Javier Velilla and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
