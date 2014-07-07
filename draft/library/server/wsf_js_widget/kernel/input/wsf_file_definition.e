note
	description: "[
		A container to encapsulate file information which is used by
		WSF_FILE_CONTROL, such as name or type of the file.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_FILE_DEFINITION

create
	make

feature {NONE}

	make (a_name, a_type: STRING_32; a_size: INTEGER; a_id: detachable STRING_32)
		do
			name := a_name
			type := a_type
			size := a_size
			id := a_id
		end

feature -- Change

	set_id (a_id: detachable STRING_32)
			-- Set the id of this abstract file.
		do
			id := a_id
		end

feature --Properties

	is_uploaded: BOOLEAN
			-- Whether the file denoted by this abstract file has been uploaded.
		do
			Result := id /= Void
		end

	name: STRING_32
			-- File name

	type: STRING_32
			-- File mime type

	size: INTEGER
			-- File size

	id: detachable STRING_32
			-- Server side file id (e.g. S3 filename)

;note
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
