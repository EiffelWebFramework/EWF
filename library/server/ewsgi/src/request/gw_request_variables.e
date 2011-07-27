note
	description: "[
				Variables/field related to the current request.
			]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	GW_REQUEST_VARIABLES

inherit
	EWSGI_VARIABLES [STRING_32]

create
	make,
	make_from_urlencoded

feature -- Initialization

	make (n: INTEGER)
		do
			create table.make (n)
			table.compare_objects
		end

	make_from_urlencoded (a_content: STRING; decoding: BOOLEAN)
		do
			make (a_content.occurrences ('&') + 1)
			import_urlencoded (a_content, decoding)
		end

feature -- Status report

	count: INTEGER
			-- Variables count
		do
			Result := table.count
		end

	variable (a_name: STRING): detachable STRING_32
		do
			Result := table.item (a_name)
		end

	has_variable (a_name: STRING): BOOLEAN
		do
			Result := table.has (a_name)
		end

feature {EWSGI_REQUEST, EWSGI_APPLICATION, EWSGI_CONNECTOR} -- Element change

	set_variable (a_name: STRING; a_value: STRING_32)
		do
			table.force (a_value, a_name)
		end

	unset_variable (a_name: STRING)
		do
			table.remove (a_name)
		end

feature -- Import urlencoded

	import_urlencoded (a_content: STRING; decoding: BOOLEAN)
			-- Import `a_content'
		local
			n, p, i, j: INTEGER
			s: STRING
			l_name,l_value: STRING_32
		do
			n := a_content.count
			if n > 0 then
				from
					p := 1
				until
					p = 0
				loop
					i := a_content.index_of ('&', p)
					if i = 0 then
						s := a_content.substring (p, n)
						p := 0
					else
						s := a_content.substring (p, i - 1)
						p := i + 1
					end
					if not s.is_empty then
						j := s.index_of ('=', 1)
						if j > 0 then
							l_name := s.substring (1, j - 1)
							l_value := s.substring (j + 1, s.count)
							if decoding then
								l_name := url_encoder.decoded_string (l_name)
								l_value := url_encoder.decoded_string (l_value)
							end
							add_variable (l_value, l_name)
						end
					end
				end
			end
		end

feature -- Access: table

	new_cursor: HASH_TABLE_ITERATION_CURSOR [STRING_32, STRING_32]
			-- Fresh cursor associated with current structure
		do
			create Result.make (table)
		end

feature {EWSGI_REQUEST} -- Element change

	add_variable (v: STRING_32; k: STRING_32)
			-- Added `k,v' to variables table
			-- Not exported to common client
			-- Simulate Read Only Access
		require
			k_attached: k /= Void
			v_attached: v /= Void
		do
			table.force (v, k)
		end

feature {EWSGI_REQUEST} -- Element change		

	table: HASH_TABLE [STRING_32, STRING_32]
			-- Variables table

feature {NONE} -- Implementation

	url_encoder: URL_ENCODER
		once
			create Result
		end

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
