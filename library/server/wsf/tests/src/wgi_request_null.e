note
	description: "Summary description for {WGI_REQUEST_NULL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WGI_REQUEST_NULL

inherit
	WGI_REQUEST_FROM_TABLE
		rename
			make as wgi_request_from_table_make
		end

create
	make

feature {NONE} -- Initialization

	make (s: WSF_SERVICE; a_meta: ARRAY [TUPLE [name: READABLE_STRING_8; value: READABLE_STRING_8]])
		local
			ht: HASH_TABLE [READABLE_STRING_8, READABLE_STRING_8]
			i: WGI_NULL_INPUT_STREAM
			c: WGI_NULL_CONNECTOR
		do
			create c.make (s)
			create i.make
			create ht.make (a_meta.count)
			across
				a_meta as curs
			loop
				ht.force (curs.item.value, curs.item.name)
			end
			wgi_request_from_table_make (ht, i, c)
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
