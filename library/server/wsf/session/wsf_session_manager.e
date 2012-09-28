note
	description: "Summary description for {WSF_SESSION_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_SESSION_MANAGER

feature -- Access

	session_exists (a_uuid: like {WSF_SESSION}.uuid): BOOLEAN
		deferred
		end

	session_data (a_uuid: like {WSF_SESSION}.uuid): detachable like {WSF_SESSION}.data
		deferred
		end

feature -- Persistence

	save_session (a_session: WSF_SESSION)
		deferred
		end

	delete_session (a_session: WSF_SESSION)
		deferred
		end

end
