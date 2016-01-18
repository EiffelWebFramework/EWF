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

	make_with_agent (c: FUNCTION [READABLE_STRING_GENERAL, JSON_ARRAY])
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

	handle_callback (cname: LIST [READABLE_STRING_GENERAL]; event: READABLE_STRING_GENERAL; event_parameter: detachable ANY)
			-- <Precursor>
		do
			Precursor {WSF_INPUT_CONTROL} (cname, event, event_parameter)
			if
				cname.first.same_string (control_name) and
				event.same_string ("autocomplete")
			then
				state_changes.put (create_json_list.item ([text]), "suggestions")
			end
		end

feature -- Properties

	create_json_list: FUNCTION [READABLE_STRING_GENERAL, JSON_ARRAY]
			-- The function which is called to give a list of suggestions to a given user input

	template: READABLE_STRING_32
			-- The template

;note
	copyright: "2011-2014, Yassin Hassan, Severin Munger, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
