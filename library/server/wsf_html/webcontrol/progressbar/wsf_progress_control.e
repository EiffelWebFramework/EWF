note
	description: "Summary description for {WSF_PROGRESS_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_PROGRESS_CONTROL

inherit

	WSF_CONTROL

create
	make_progress

feature {NONE} -- Initialization

	make_progress (n: STRING; p: WSF_PROGRESSSOURCE)
		do
			make_control (n, "div")
			add_class ("progress")
			progress_source := p
		end

feature -- State handling

	set_state (new_state: JSON_OBJECT)
		do
		end

	state: JSON_OBJECT
		do
			create Result.make
			Result.put (create {JSON_NUMBER}.make_integer (progress_source.progress), "progress")
		end

feature -- Event handling

	handle_callback (cname: STRING; event: STRING)
		do
			if cname.is_equal (control_name) and event.is_equal ("progress_fetch") then
				state_changes.put (create {JSON_NUMBER}.make_integer (progress_source.progress), create {JSON_STRING}.make_json ("progress"))
			end
		end

feature -- Rendering

	render: STRING
		do
			Result := render_tag_with_tagname ("div", "", "role=%"progressbar%" aria-valuenow=%"" + progress_source.progress.out + "%" aria-valuemin=%"0%" aria-valuemax=%"100%" style=%"width: " + progress_source.progress.out + "%%;%"", "progress-bar")
			Result := render_tag (Result, "")
		end

feature

	progress_source: WSF_PROGRESSSOURCE

end
