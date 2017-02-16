note
	description: "[
			Basic database for simple example based on memory.

			WARNING: for now, not concurrent compliant.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	BASIC_MEMORY_DATABASE

inherit
	BASIC_DATABASE

create
	make

feature {NONE} -- Initialization

	make
		do
			create collections.make (0)
		end

	collections: HASH_TABLE [STRING_TABLE [detachable ANY], TYPE [detachable ANY]]

feature -- Access

	count_of (a_entry_type: TYPE [detachable ANY]): INTEGER
		do
			if attached collections.item (a_entry_type) as tb then
				Result := tb.count
			end
		end

	has (a_entry_type: TYPE [detachable ANY]; a_id: READABLE_STRING_GENERAL): BOOLEAN
			-- Has entry of type `a_entry_type` associated with id `a_id`?
		do
			if attached collections.item (a_entry_type) as tb then
				Result := tb.has_key (a_id)
			end
		end

	item (a_entry_type: TYPE [detachable ANY]; a_id: READABLE_STRING_GENERAL): detachable ANY
		do
			if attached collections.item (a_entry_type) as tb then
				Result := tb.item (a_id)
			end
		end

	save (a_entry_type: TYPE [detachable ANY]; a_entry: detachable ANY; cl_entry_id: CELL [detachable READABLE_STRING_GENERAL])
		local
			tb: detachable STRING_TABLE [detachable ANY]
			l_id: detachable READABLE_STRING_GENERAL
		do
			tb := collections.item (a_entry_type)
			if tb = Void then
				create tb.make (100)
				collections.force (tb, a_entry_type)
			end
			l_id := cl_entry_id.item
			if l_id = Void then
				l_id := next_identifier (a_entry_type)
				cl_entry_id.replace (l_id)
			end
			tb.force (a_entry, l_id)
		end

	delete (a_entry_type: TYPE [detachable ANY]; a_id: READABLE_STRING_GENERAL)
		do
			if attached collections.item (a_entry_type) as tb then
				tb.remove (a_id)
			end
		end

feature {NONE} -- Implementation

	next_identifier (a_entry_type: TYPE [detachable ANY]): STRING_8
		local
			i: INTEGER
			f: RAW_FILE
			s: STRING
		do
			if attached collections.item (a_entry_type) as tb then
				i := tb.count
			else
				i := 0
			end
			from
				i := i + 1
				Result := i.out
			until
				not has (a_entry_type, Result)
			loop
				i := i + 1
				Result := i.out
			end
		end

note
	copyright: "2011-2017, Javier Velilla and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
