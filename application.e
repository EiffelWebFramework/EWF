note
	description : "nino application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_server : HTTP_SERVER
		do
			create l_server.make
			l_server.setup
		end

end
