note
	description: "Summary description for {WSF_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_CONTROL

feature

	control_name: STRING

feature {WSF_PAGE_CONTROL, WSF_CONTROL}

	handle_callback (event: STRING; cname: STRING; page: WSF_PAGE_CONTROL)
		deferred
		end

	render: STRING
		deferred
		end

	state: JSON_OBJECT
		deferred
		end

	read_state (states: JSON_OBJECT)
		do
			states.put (state, create {JSON_STRING}.make_json (control_name))
		end

end
