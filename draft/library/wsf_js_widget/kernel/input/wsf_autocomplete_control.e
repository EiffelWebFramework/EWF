note
	description: "Summary description for {WSF_AUTOCOMPLETE_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_AUTOCOMPLETE_CONTROL

inherit

	WSF_INPUT_CONTROL
		redefine
			handle_callback,
			state
		end

create
	make_autocomplete, make_autocomplete_with_agent

feature {NONE} -- Initialization

	make_autocomplete (n: STRING; c: WSF_AUTOCOMPLETION)
			-- Initialize with specified name and autocompletion
		do
			make_autocomplete_with_agent (n, agent c.autocompletion)
			if attached c.template as t then
				template := t
			end
		end

	make_autocomplete_with_agent (n: STRING; c: FUNCTION [ANY, TUPLE [STRING], JSON_ARRAY])
			-- Initialize with specified name and autocompletion function
		do
			make_input (n, "")
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

	handle_callback (cname: STRING; event: STRING; event_parameter: detachable STRING)
		do
			Precursor {WSF_INPUT_CONTROL} (cname, event, event_parameter)
			if cname.same_string (control_name) and event.same_string ("autocomplete") then
				state_changes.put (create_json_list.item ([text]), "suggestions")
			end
		end

feature -- Properties

	create_json_list: FUNCTION [ANY, TUPLE [STRING], JSON_ARRAY]

	template: STRING

end
