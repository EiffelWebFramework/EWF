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

	
end

	
