note

	description: "Conforming handlers for HTTP 1.1 standard methods"

	author: "Colin Adams"
	date: "$Date$"
	revision: "$Revision$"

deferred class	WSF_METHOD_HANDLERS

inherit

	WSF_METHOD_HANDLER
		rename
			do_method as do_get
		select
			do_get
		end

	WSF_METHOD_HANDLER
		rename
			do_method as do_put
		end

	WSF_METHOD_HANDLER
		rename
			do_method as do_put
		end

	WSF_METHOD_HANDLER
		rename
			do_method as do_connect
		end

	WSF_METHOD_HANDLER
		rename
			do_method as do_head
		end

	WSF_METHOD_HANDLER
		rename
			do_method as do_options
		end

	WSF_METHOD_HANDLER
		rename
			do_method as do_trace
		end

feature -- Method

	do_head (a_req: WSF_REQUEST; a_res: WSF_RESPONSE)
			-- Respond to `a_req' using `a_res'.
		deferred
		ensure then
			empty_body: is_empty_content (a_res)			
		end

	do_post (a_req: WSF_REQUEST; a_res: WSF_RESPONSE)
			-- Respond to `a_req' using `a_res'.
		deferred
		ensure then
			non_empty_body: a_res.status_code =  {HTTP_STATUS_CODE}.created implies
				not is_empty_content (a_res)
			location_header: a_res.status_code =  {HTTP_STATUS_CODE}.created implies True -- WSF_RESPONSE needs enhancing
		end

	do_trace (a_req: WSF_REQUEST; a_res: WSF_RESPONSE)
			-- Respond to `a_req' using `a_res'.
		deferred
		ensure then
			non_empty_body: a_res.status_code =  {HTTP_STATUS_CODE}.ok implies
				not is_empty_content (a_res)
		end

end

	
