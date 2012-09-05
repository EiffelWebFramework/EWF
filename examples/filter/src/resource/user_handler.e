note
	description: "User handler."
	author: "Olivier Ligot"
	date: "$Date$"
	revision: "$Revision$"

class
	USER_HANDLER [C -> WSF_HANDLER_CONTEXT]

inherit
	WSF_FILTER_HANDLER [C]

	WSF_RESOURCE_HANDLER_HELPER [C]
		redefine
			do_get
		end

	SHARED_DATABASE_API

	SHARED_EJSON

feature -- Basic operations

	execute (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler	
		do
			execute_methods (ctx, req, res)
		end

	do_get (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Using GET to retrieve resource information.
			-- If the GET request is SUCCESS, we response with
			-- 200 OK, and a representation of the user
			-- If the GET request is not SUCCESS, we response with
			-- 404 Resource not found
		local
			id :  STRING
		do
			if attached req.orig_path_info as orig_path then
				id := get_user_id_from_path (orig_path)
				if attached retrieve_user (id) as l_user then
					compute_response_get (ctx, req, res, l_user)
				else
					handle_resource_not_found_response ("The following resource " + orig_path + " is not found ", ctx, req, res)
				end
			end
		end

feature {NONE} -- Implementation

	compute_response_get (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE; l_user : USER)
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
