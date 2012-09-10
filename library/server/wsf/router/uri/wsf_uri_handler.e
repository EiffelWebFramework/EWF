note
	description: "Summary description for {EWF_ROUTER_URI_PATH_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_URI_HANDLER

inherit
	WSF_HANDLER

feature -- Execution

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
		deferred
		end

end
