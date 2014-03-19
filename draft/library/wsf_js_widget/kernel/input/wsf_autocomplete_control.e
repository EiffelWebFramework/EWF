note
	description: "[
		A control that can be used for autocompletion. A customizable
		template can be passed to this class in a WSF_AUTOCOMPLETION
		instance.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_AUTOCOMPLETE_CONTROL

inherit

	WSF_INPUT_CONTROL
		rename
			make as make_input
		redefine
			handle_callback,
			state
		end

create
	make, make_with_agent

feature {NONE} -- Initialization

	make (c: WSF_AUTOCOMPLETION)
			-- Initialize with specified autocompletion
		do
			make_with_agent (agent c.autocompletion)
			if attached c.template as t then
				template := t
			end
		end

	make_with_agent (c: FUNCTION [ANY, TUPLE [STRING_32], JSON_ARRAY])
			-- Initialize with autocompletion function
		do
			make_input ("")
			create_json_list := c
			template := "{{=value}}"
		end

feature -- State

	state: WSF_JSON_OBJECT
		do
			Result := Precursor {WSF_INPUT_CONTROL}
			Result.put_string (template, "template")
		end

feature -- Callback

	handle_callback (cname: LIST [STRING_32]; event: STRING_32; event_parameter: detachable ANY)
		do
			Precursor {WSF_INPUT_CONTROL} (cname, event, event_parameter)
			if cname [1].same_string (control_name) and event.same_string ("autocomplete") then
				state_changes.put (create_json_list.item ([text]), "suggestions")
			end
		end

feature -- Properties

	create_json_list: FUNCTION [ANY, TUPLE [STRING_32], JSON_ARRAY]
			-- The function which is called to give a list of suggestions to a given user input

	template: STRING_32
			-- The template

end
