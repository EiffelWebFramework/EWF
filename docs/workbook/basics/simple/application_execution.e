note
	description : "Basic Service that Generates Plain Text"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION_EXECUTION

inherit
	WSF_EXECUTION

create
	make

feature -- Basic operations

	execute
			-- Execute the incomming request
		do
				-- To send a response we need to setup, the status code and
				-- the response headers.
			response.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/plain"], ["Content-Length", "11"]>>)
			response.put_string ("Hello World")
		end
end
