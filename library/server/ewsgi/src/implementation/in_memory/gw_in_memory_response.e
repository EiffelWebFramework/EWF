note
	description: "Summary description for {GW_IN_MEMORY_RESPONSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GW_IN_MEMORY_RESPONSE

inherit
	GW_RESPONSE
		redefine
			commit
		end

create {GW_APPLICATION}
	make

feature {NONE} -- Initialization

	make
		do
			create header.make
			create body.make (100)
		end

	header: GW_HEADER

	body: STRING_8

feature -- Status setting

	set_status_code (c: INTEGER)
			-- Set the status code of the response
		do
			header.put_status (c)
		end

feature -- Output operation

	write_string (s: STRING)
			-- Send the content of `s'
		do
			body.append (s)
		end

	write_file_content (fn: STRING)
			-- Send the content of file `fn'
		local
			f: RAW_FILE
		do
			create f.make (fn)
			if f.exists and then f.is_readable then
				f.open_read
				from
				until
					f.exhausted
				loop
					f.read_stream (1024)
					write_string (f.last_string)
				end
				f.close
			end
		end

	write_header_object (h: GW_HEADER)
			-- Send `header' to `output'.
		do
			header := h
		end

feature {GW_APPLICATION} -- Commit

	commit (a_output: GW_OUTPUT_STREAM)
		do
			header.send_to (a_output)
			write_string (body)
			Precursor (a_output)
		end

;note
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
