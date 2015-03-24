note
	description: "Summary description for {SERVICE_FILE_EXECUTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SERVICE_FILE_EXECUTION

inherit
	WSF_EXECUTION

create
	make

feature {NONE} -- Initialization

	execute
		local
			f: WSF_FILE_RESPONSE
		do
			create f.make_html ("home.html")
			response.send (f)
		end

end
