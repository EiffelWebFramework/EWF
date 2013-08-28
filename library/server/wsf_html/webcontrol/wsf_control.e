note
	description: "Summary description for {WSF_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_CONTROL

feature

	control_name: STRING

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- STATE MANAGEMENT

	load_state (new_states: JSON_OBJECT)
		local
			new_state: detachable JSON_VALUE
		do
			new_state := new_states.item (create {JSON_STRING}.make_json (control_name))
			if attached {JSON_OBJECT} new_state as new_state_obj then
				set_state (new_state_obj)
			end
		end

	read_state (states: JSON_OBJECT)
		do
			states.put (state, create {JSON_STRING}.make_json (control_name))
		end

	set_state (new_state: JSON_OBJECT)
		deferred
		end

	state: JSON_OBJECT
		deferred
		end

feature --EVENT HANDLING

	handle_callback (cname: STRING; event: STRING)
		deferred
		end

feature

	render: STRING
		deferred
		end

end
