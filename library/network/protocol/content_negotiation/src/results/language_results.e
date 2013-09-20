note
	description: "Object that represents a result after parsing Language Headers."
	date: "$Date$"
	revision: "$Revision$"

class
	LANGUAGE_RESULTS

create
	make

feature -- Initialization

	make
			--Create an object LANGUAGE_RESULTS.
		do
			create params.make (2)
			create mime_type.make_from_string ("*")
		end

feature -- Access

	type: detachable STRING

	sub_type: detachable STRING

	mime_type: STRING

	item (a_key: STRING): detachable STRING
			-- Item associated with `a_key', if present
			-- otherwise default value of type `STRING'
		do
			Result := params.item (a_key)
		end

	keys: LIST [STRING]
			-- arrays of currents keys
		local
			res: ARRAYED_LIST [STRING]
		do
			create res.make_from_array (params.current_keys)
			Result := res
		end

	params: HASH_TABLE [STRING, STRING]
			--dictionary of all the parameters for the media range

feature -- Status Report

	has_key (a_key: STRING): BOOLEAN
			-- Is there an item in the table with key `a_key'?
		do
			Result := params.has_key (a_key)
		end

feature -- Element change

	set_type (a_type: STRING)
			-- Set type with `a_type'
		do
			type := a_type
			if attached sub_type as st then
				mime_type := a_type + "-" + st
			else
				mime_type := a_type
			end
		ensure
			type_assigned: type ~ a_type
		end

	set_sub_type (a_sub_type: STRING)
			-- Set sub_type with `a_sub_type
		do
			sub_type := a_sub_type
			if attached type as t then
				mime_type := t + "-" + a_sub_type
			else
				mime_type := "*"
			end
		ensure
			sub_type_assigned: sub_type ~ a_sub_type
		end

	put (new: STRING; key: STRING)
			-- Insert `new' with `key' if there is no other item
			-- associated with the same key. If present, replace
			-- the old value with `new'
		do
			if params.has_key (key) then
				params.replace (new, key)
			else
				params.force (new, key)
			end
		ensure
			has_key: params.has_key (key)
			has_item: params.has_item (new)
		end

feature -- Status Report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := out
		end


note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
