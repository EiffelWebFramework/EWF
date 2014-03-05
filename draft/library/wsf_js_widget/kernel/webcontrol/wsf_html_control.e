note
	description: "[
		A convenience class that can be used to insert custom html code.
		This class is a value control which means that the html text can
		be updated.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_HTML_CONTROL

inherit

	WSF_VALUE_CONTROL [STRING_32]
		rename
			make as make_value_control
		end

create
	make

feature {NONE} -- Initialization

	make (t, v: STRING_32)
			-- Initialize
		do
			make_value_control (t)
			html := v
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	set_state (new_state: JSON_OBJECT)
			-- Restore html from json
		do
			if attached {JSON_STRING} new_state.item ("html") as new_html then
				html := new_html.unescaped_string_32
			end
		end

	state: WSF_JSON_OBJECT
			-- Return state which contains the current html and if there is an event handle attached
		do
			create Result.make
			Result.put_string (html, "html")
		end

feature --Event handling

	handle_callback (cname: LIST [STRING_32]; event: STRING_32; event_parameter: detachable ANY)
		do
		end

feature -- Implementation

	render: STRING_32
			-- HTML representation of this html control
		do
			Result := render_tag (html, "")
		end

	set_html (t: STRING_32)
		do
			if not t.same_string (html) then
				html := t
				state_changes.replace_with_string (html, "html")
			end
		end

	value: STRING_32
		do
			Result := html
		end

	set_value (v: STRING_32)
		do
			html := v
		end

feature -- Properties

	html: STRING_32

end
