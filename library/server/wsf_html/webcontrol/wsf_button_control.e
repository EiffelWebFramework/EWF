note
	description: "Summary description for {WSF_BUTTON_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_BUTTON_CONTROL

inherit

	WSF_CONTROL

create
	make

feature {NONE}

	make (n: STRING; v: STRING)
		do
			control_name := n
			text := v
			click_event := agent donothing
		end

feature

		--UGLY HACK MUST BE REMOVED

	donothing (p: WSF_PAGE_CONTROL)
		do
		end

	set_click_event (e: PROCEDURE [ANY, TUPLE [WSF_PAGE_CONTROL]])
		do
			click_event := e
		end

	handle_callback (cname: STRING; event: STRING; page: WSF_PAGE_CONTROL)
		do
			if Current.control_name.is_equal (cname) and attached click_event then
				click_event.call ([page])
			end
		end

	render: STRING
		do
			Result := "<button data-name=%"" + control_name + "%" data-type=%"WSF_BUTTON_CONTROL%">" + text + "</button>"
		end

	state: JSON_OBJECT
		do
			create Result.make
			Result.put (create {JSON_STRING}.make_json (text), create {JSON_STRING}.make_json ("text"))
		end

	set_text (t: STRING)
		do
			text := t
		end

feature

	text: STRING

	click_event: PROCEDURE [ANY, TUPLE [WSF_PAGE_CONTROL]]

end
