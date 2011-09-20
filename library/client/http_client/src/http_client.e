note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

deferred class
	HTTP_CLIENT

feature -- Status

	new_session (a_base_url: READABLE_STRING_8): HTTP_CLIENT_SESSION
		deferred
		end

end
