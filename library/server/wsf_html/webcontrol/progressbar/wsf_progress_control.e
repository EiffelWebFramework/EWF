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
	make_progress, make_progress_with_source

feature {NONE} -- Initialization

	make_progress (n: STRING)
		do
			make_control (n, "div")
			add_class ("progress")
			progress := 0
		end

	make_progress_with_source (n: STRING; p: WSF_PROGRESSSOURCE)
		do
			make_progress (n)
			progress_source := p
		end

feature -- State handling

	set_state (new_state: JSON_OBJECT)
		do
			if attached {JSON_NUMBER} new_state.item (create {JSON_STRING}.make_json ("progress")) as new_progress then
				progress := new_progress.item.to_integer
			end
		end

	state: JSON_OBJECT
		do
			create Result.make
			Result.put (create {JSON_NUMBER}.make_integer (progress_value), "progress")
		end

feature -- Event handling

	handle_callback (cname: STRING; event: STRING; event_parameter: detachable STRING)
		do
			if cname.is_equal (control_name) and event.is_equal ("progress_fetch") then
				state_changes.put (create {JSON_NUMBER}.make_integer (progress_value), create {JSON_STRING}.make_json ("progress"))
			end
		end

feature -- Rendering

	render: STRING
		local
			p: STRING
		do
			p := progress_value.out
			Result := render_tag_with_tagname ("div", "", "role=%"progressbar%" aria-valuenow=%"" + p + "%" aria-valuemin=%"0%" aria-valuemax=%"100%" style=%"width: " + p + "%%;%"", "progress-bar")
			Result := render_tag (Result, "")
		end

feature --Change progress

	set_progress (p: INTEGER)
		require
			no_progress_source: not (attached progress_source)
		do
			progress := p
			state_changes.put (create {JSON_NUMBER}.make_integer (progress), create {JSON_STRING}.make_json ("progress"))
		end

feature

	progress_source: detachable WSF_PROGRESSSOURCE

	progress: INTEGER

	progress_value: INTEGER
		do
			Result := progress
			if attached progress_source as ps then
				Result := ps.progress
			end
		end

end
