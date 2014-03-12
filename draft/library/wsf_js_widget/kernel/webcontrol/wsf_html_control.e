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

	make (tag, v: STRING_32)
			-- Initialize with specified tag and HTML value
		require
			tag_not_empty: not tag.is_empty
		do
			make_value_control (tag)
			html := v
		ensure
			html_set: html.same_string (v)
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	set_state (new_state: JSON_OBJECT)
			-- Restore HTML from json
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
			-- By default, this does nothing
		do
		end

feature -- Implementation

	render: STRING_32
			-- HTML representation of this html control
		do
			Result := render_tag (html, "")
		end

	value: STRING_32
			-- The HTML value of this HTML control
		do
			Result := html
		ensure then
			result_set: Result.same_string (html)
		end

	set_value (v: STRING_32)
			-- Set HTML value of this control
		do
			if not v.same_string (html) then
				html := v
				state_changes.replace_with_string (html, "html")
			end
		ensure then
			html_set: html.same_string (v)
		end

feature -- Properties

	html: STRING_32
			-- The HTML value of this HTML control

end
