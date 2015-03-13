note
	description: "Summary description for {APP_WSF_EXECUTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	APP_WSF_EXECUTION

inherit
	WSF_EXECUTION

create
	make

feature -- Execution

	execute
		local
			s: STRING
		do
			s := "Hello Concurrent EWF"
			s.append (" (counter=")
			s.append_integer (next_cell_counter_item (counter_cell))
			s.append (")%N")

			response.set_status_code (200)
			response.put_header_line ("X-EWF-Dev: v1.0")
			response.header.put_content_type_text_plain
			response.header.put_content_length (s.count)

			response.put_string (s)
		end

	next_cell_counter_item (cl: like counter_cell): INTEGER
		do
			Result := cl.next_item
		end

	counter_cell: separate APP_COUNTER
		once ("PROCESS")
			create Result.put (0)
		end


note
	copyright: "2011-2015, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
