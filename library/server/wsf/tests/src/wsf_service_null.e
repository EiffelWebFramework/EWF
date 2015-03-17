note
	description: "Summary description for {WSF_SERVICE_NULL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_SERVICE_NULL

inherit

	WSF_SERVICE


feature -- Execute	
	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the request
			-- See `req.input' for input stream
    		--     `req.meta_variables' for the CGI meta variable
			-- and `res' for output buffer
		do
		end
end
