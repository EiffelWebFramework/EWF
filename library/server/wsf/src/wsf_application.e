note
	description: "Objects that ..."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_APPLICATION

inherit
	WGI_APPLICATION
		rename
			execute as wgi_execute
		end

feature -- Execution

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the request
			-- See `req.input' for input stream
    		--     `req.meta_variables' for the CGI meta variable
			-- and `res' for output buffer
		deferred
		end

feature -- WGI Execution

	wgi_execute (req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
		do
			execute (create {WSF_REQUEST}.make_from_wgi (req), create {WSF_RESPONSE}.make_from_wgi (res))
		end

end
