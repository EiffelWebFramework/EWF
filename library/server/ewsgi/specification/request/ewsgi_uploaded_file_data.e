note
	description: "Summary description for {GW_UPLOADED_FILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EWSGI_UPLOADED_FILE_DATA

create
	make

feature {NONE} -- Initialization

	make (n: like name; t: like content_type; s: like size)
		do
			name := n
			content_type := t
			size := s
		end

feature -- Access

	name: STRING
			-- original filename

	content_type: STRING
			-- Content type

	size: INTEGER
			-- Size of uploaded file

	tmp_name: detachable STRING
			-- Filename of tmp file

	tmp_basename: detachable STRING
			-- Basename of tmp file

feature -- Basic operation

	move_to (a_destination: STRING): BOOLEAN
			-- Move current uploaded file to `a_destination'
		require
			has_no_error: not has_error
		local
			f: RAW_FILE
		do
			if attached tmp_name as n then
				create f.make (n)
				if f.exists then
					f.change_name (a_destination)
					Result := True
				end
			end
		end

feature --  Status

	has_error: BOOLEAN
			-- Has error during uploading
		do
			Result := error /= 0
		end

	error: INTEGER
			-- Eventual error code
			--| no error => 0

feature -- Element change

	set_error (e: like error)
			-- Set `error' to `e'
		do
			error := e
		end

	set_tmp_name (n: like tmp_name)
			-- Set `tmp_name' to `n'
		do
			tmp_name := n
		end

	set_tmp_basename (n: like tmp_basename)
			-- Set `tmp_basename' to `n'
		do
			tmp_basename := n
		end

invariant

	valid_tmp_name: not has_error implies attached tmp_name as n and then not n.is_empty

note
	copyright: "2011-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
