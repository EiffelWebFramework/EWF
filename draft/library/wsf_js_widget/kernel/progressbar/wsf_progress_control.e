note
	description: "[
			WSF_PROGRESS_CONTROL encapsulates the progress bar provided by bootstrap.
			The value of the progress bar can either be set directly using set_progress
			or it can be fetched from a progress source.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_PROGRESS_CONTROL

inherit

	WSF_CONTROL
		rename
			make as make_control
		end

create
	make, make_with_source

feature {NONE} -- Initialization

	make
			-- Initialize with specified control name
		do
			make_control ("div")
			add_class ("progress")
			progress := 0
		end

	make_with_source ( p: WSF_PROGRESS_SOURCE)
			-- Initialize with specified control name and progresssource
		do
			make
			progress_source := p
		end

feature -- State handling

	set_state (new_state: JSON_OBJECT)
		do
			if attached {JSON_NUMBER} new_state.item ("progress") as new_progress then
				progress := new_progress.item.to_integer
			end
		end

	state: WSF_JSON_OBJECT
		do
			create Result.make
			Result.put_integer (progress_value, "progress")
		end

feature -- Event handling

	handle_callback (cname: LIST[STRING_32]; event: STRING_32; event_parameter: detachable ANY)
		do
			if cname[1].same_string (control_name) and event.same_string ("progress_fetch") then
				state_changes.put_integer (progress_value, "progress")
			end
		end

feature -- Rendering

	render: STRING_32
		local
			p: STRING_32
		do
			p := progress_value.out
			Result := render_tag_with_tagname ("div", "", "role=%"progressbar%" aria-valuenow=%"" + p + "%" aria-valuemin=%"0%" aria-valuemax=%"100%" style=%"width: " + p + "%%;%"", "progress-bar")
			Result := render_tag (Result, "")
		end

feature -- Change

	set_progress (p: INTEGER)
			-- Set current progress value to specified value. Must be between 0 and 100. Must only be called when no progresssource has been set to this progress control
		require
			no_progress_source: not (attached progress_source)
			valid_input_value: p >= 0 and p <= 100
		do
			progress := p
			state_changes.put_integer (progress, "progress")
		end

feature -- Implementation

	progress_value: INTEGER
		do
			Result := progress
			if attached progress_source as ps then
				Result := ps.progress
			end
		end

feature -- Properties

	progress_source: detachable WSF_PROGRESS_SOURCE

	progress: INTEGER

end
