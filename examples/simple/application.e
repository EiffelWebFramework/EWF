note
	description : "simple application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	DEFAULT_SERVICE

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			make_and_launch
		end

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			-- To send a response we need to setup, the status code and
			-- the response headers.
			res.set_status_code ({HTTP_STATUS_CODE}.ok)
			res.write_header_text ("")
			res.write_string ("Hello World")
		end
end
