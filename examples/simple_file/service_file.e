note
	description : "simple application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	SERVICE_FILE

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
		local
			l_file : RAW_FILE
			message : STRING
			h : WSF_HEADER
		do
			create l_file.make_open_read ("home.html")
			l_file.read_stream (l_file.count)
			message := l_file.last_string
			l_file.close

			-- To send a response we need to setup, the status code and
			-- the response headers.
			create h.make
			h.put_content_type_text_html
			h.put_content_length (l_file.count)
			res.set_status_code ({HTTP_STATUS_CODE}.ok)
			res.write_header_text (h.string)
			res.write_string (message)
		end
end
