note
	description: "[
		Representation of a list of HTML checkboxes.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_CHECKBOX_LIST_CONTROL

inherit

	WSF_VALUE_CONTROL [LIST [STRING_32]]
		rename
			make as make_control
		undefine
			load_state,
			full_state,
			read_state_changes
		end

	WSF_MULTI_CONTROL [WSF_CHECKBOX_CONTROL]
		rename
			make as make_multi_control
		end

create
	make

feature {NONE} -- Initializaton

	make
			-- Initialize with specified control name
		do
			make_multi_control
		end

feature -- Implementation

	value: LIST [STRING_32]
			-- Returns the values of all selected checkboxes in this list
		do
			create {ARRAYED_LIST [STRING_32]} Result.make (0)
			across
				controls as c
			loop
				if c.item.checked then
					Result.extend (c.item.checked_value)
				end
			end
		end

	set_value (v: LIST [STRING_32])
			-- Sets the checked state of each of the checkboxes in this list according to whether the value
			-- of a checkbox occurs in the specified list or not
		do
			across
				controls as c
			loop
				c.item.set_checked (v.has (c.item.checked_value))
			end
		end

end
