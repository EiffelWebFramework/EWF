note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	LIBCURL_HTTP_CLIENT

inherit
	HTTP_CLIENT

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
		end

feature -- Status

	new_session (a_base_url: READABLE_STRING_8): LIBCURL_HTTP_CLIENT_SESSION
		do
			create Result.make (a_base_url)
		end

end
