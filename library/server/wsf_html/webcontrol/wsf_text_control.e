note
	description: "Summary description for {WSF_TEXT_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_TEXT_CONTROL

inherit

	WSF_CONTROL

create
	make

feature {NONE}

	make (n: STRING; v: STRING)
		do
			control_name := n
			text := v
			change_event := agent donothing
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- STATE MANAGEMENT

	set_state (new_state: JSON_OBJECT)
		do
			if attached {JSON_STRING} new_state.item (create {JSON_STRING}.make_json ("text")) as new_text then
				text := new_text.unescaped_string_32
			end
		end

	state: JSON_OBJECT
		do
			create Result.make
			Result.put (create {JSON_STRING}.make_json (text), create {JSON_STRING}.make_json ("text"))
		end

feature --EVENT HANDLING

	donothing (p: WSF_PAGE_CONTROL) --UGLY HACK MUST BE REMOVED
		do
		end

	set_change_event (e: PROCEDURE [ANY, TUPLE [WSF_PAGE_CONTROL]])
		do
			change_event := e
		end

	handle_callback (cname: STRING; event: STRING; page: WSF_PAGE_CONTROL)
		do
			if Current.control_name.is_equal (cname) and attached change_event then
				if event.is_equal ("change") then
					change_event.call ([page])
				end
			end
		end

feature

	render: STRING
		do
			Result := "<input type=%"text%" data-name=%"" + control_name + "%" data-type=%"WSF_TEXT_CONTROL%" value=%"" + text + "%" />"
		end

	set_text (t: STRING)
		do
			text := t
		end

feature

	text: STRING

	change_event: PROCEDURE [ANY, TUPLE [WSF_PAGE_CONTROL]]

end
