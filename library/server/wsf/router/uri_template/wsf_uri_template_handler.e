note
	description: "Summary description for EWF_URI_TEMPLATE_HANDLER."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_URI_TEMPLATE_HANDLER

inherit
	WSF_HANDLER

feature -- Execution

	execute (ctx: WSF_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE)
		deferred
		end

end
