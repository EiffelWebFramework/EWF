note
	description : "simple application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	SERVICE_FILE

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			s: DEFAULT_SERVICE
		do
			create s.make_and_launch (agent execute)
		end

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			f: WSF_FILE_RESPONSE
		do
			create f.make_html ("home.html")
			res.put_response (f)
		end
end
