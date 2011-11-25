note
	description: "[
		Inherit from this class to implement the main entry of your web service
		You just need to implement `execute', get data from the request `req'
		and write the response in `res'
	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_SERVICE

inherit
	WGI_SERVICE
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

	wgi_execute (req: WGI_REQUEST; res: WGI_RESPONSE)
		do
			execute (create {WSF_REQUEST}.make_from_wgi (req), create {WSF_RESPONSE}.make_from_wgi (res))
		end

end
