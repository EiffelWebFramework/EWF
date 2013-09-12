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
			handle_callback
		end

create
	make_autocomplete, make_autocomplete_with_agent

feature {NONE} -- Creation

	make_autocomplete (n: STRING; c: WSF_AUTOCOMPLETION)
		do
			make_autocomplete_with_agent (n, agent c.autocompletion)
		end

	make_autocomplete_with_agent (n: STRING; c: FUNCTION [ANY, TUPLE [STRING], JSON_ARRAY])
		do
			make_input (n, "")
			create_json_list := c
		end

feature -- Callback

	handle_callback (cname: STRING; event: STRING)
		do
			Precursor {WSF_INPUT_CONTROL} (cname, event)
			if cname.is_equal (control_name) and event.is_equal ("autocomplete") then
				state_changes.put (create_json_list.item ([text]), create {JSON_STRING}.make_json ("suggestions"))
			end
		end

feature -- Autocomplete

	create_json_list: FUNCTION [ANY, TUPLE [STRING], JSON_ARRAY]

end
