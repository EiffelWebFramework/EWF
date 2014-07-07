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
			-- Initialize
		do
			make_control ("div")
			add_class ("progress")
			progress := 0
		end

	make_with_source (p: WSF_PROGRESS_SOURCE)
			-- Initialize with specified progresssource
		do
			make
			progress_source := p
		ensure
			progress_source_set: progress_source = p
		end

feature -- State handling

	set_state (new_state: JSON_OBJECT)
		require else
			progress_in_range: attached {JSON_NUMBER} new_state.item ("progress") as new_progress implies new_progress.item.to_integer >= 0 and new_progress.item.to_integer <= 100
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

	handle_callback (cname: LIST [READABLE_STRING_GENERAL]; event: READABLE_STRING_GENERAL; event_parameter: detachable ANY)
		do
			if
				cname.first.same_string (control_name) and
				event.same_string ("progress_fetch")
			then
				state_changes.put_integer (progress_value, "progress")
			end
		end

feature -- Rendering

	render: STRING_32
		local
			p: STRING_32
		do
			p := progress_value.out
				-- FIXME: string 32 truncated to string 8 !!!
			Result := render_tag_with_tagname ("div", "", "role=%"progressbar%" aria-valuenow=%"" + p + "%" aria-valuemin=%"0%" aria-valuemax=%"100%" style=%"width: " + p + "%%;%"", "progress-bar")
			Result := render_tag (Result, "")
		end

feature -- Change

	set_progress (p: INTEGER)
			-- Set current progress value to specified value. Must be between 0 and 100. Must only be called when no progresssource has been set to this progress control
		require
			no_progress_source: progress_source = Void
			valid_input_value: p >= 0 and p <= 100
		do
			progress := p
			state_changes.put_integer (progress, "progress")
		ensure
			progress_set: progress = p
			state_changes_registered: state_changes.has_key ("progress")
		end

feature -- Implementation

	progress_value: INTEGER
			-- The progress value of this progress control
		do
			Result := progress
			if attached progress_source as ps then
				Result := ps.progress
			end
		ensure
			result_in_range: Result >= 0 and Result <= 100
		end

feature -- Properties

	progress_source: detachable WSF_PROGRESS_SOURCE
			-- The source which provides this progress control the progress value

	progress: INTEGER
			-- The progress value of this progress control

invariant
	progress_in_range: progress >= 0 and progress <= 100

note
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
