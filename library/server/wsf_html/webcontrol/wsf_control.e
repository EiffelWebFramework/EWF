note
	description: "Summary description for {WSF_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_CONTROL
feature
	name: STRING

feature {WSF_PAGE_CONTROL}

	handle_callback(event: STRING ; control_name: STRING ; page: WSF_PAGE_CONTROL)
	deferred
	end

	render:STRING
	deferred
	end
end
