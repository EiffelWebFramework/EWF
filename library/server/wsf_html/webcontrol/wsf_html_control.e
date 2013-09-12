note
	description: "Summary description for {WSF_html_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_HTML_CONTROL

inherit

	WSF_VALUE_CONTROL [STRING]

create
	make_html

feature {NONE}

	make_html (n, t, v: STRING)
		do
			make_control (n, t)
			html := v
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- STATE MANAGEMENT

	set_state (new_state: JSON_OBJECT)
			-- Restore html from json
		do
			if attached {JSON_STRING} new_state.item (create {JSON_STRING}.make_json ("html")) as new_html then
				html := new_html.unescaped_string_32
			end
		end

	state: JSON_OBJECT
			-- Return state which contains the current html and if there is an event handle attached
		do
			create Result.make
			Result.put (create {JSON_STRING}.make_json (html), create {JSON_STRING}.make_json ("html"))
		end

feature --EVENT HANDLING

	handle_callback (cname: STRING; event: STRING)
		do
		end

feature -- Implementation

	render: STRING
		do
			Result := render_tag (html, "")
		end

	set_html (t: STRING)
		do
			if not t.is_equal (html) then
				html := t
				state_changes.replace (create {JSON_STRING}.make_json (html), create {JSON_STRING}.make_json ("html"))
			end
		end

	value: STRING
		do
			Result := html
		end

feature

	html: STRING

end
