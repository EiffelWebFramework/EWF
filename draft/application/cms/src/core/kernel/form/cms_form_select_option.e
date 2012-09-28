note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	CMS_FORM_SELECT_OPTION

create
	make

feature {NONE} -- Initialization

	make (a_value: like value; a_text: detachable like text)
			-- Initialize `Current'.
		do
			value := a_value
			if a_text = Void then
				text := a_value
			else
				text := a_text
			end
		end

feature -- Status

	is_selected: BOOLEAN

feature -- Access

	value: READABLE_STRING_8

	text: READABLE_STRING_8

	description: detachable READABLE_STRING_8

feature -- Change

	set_is_selected (b: like is_selected)
		do
			is_selected := b
		end
		
	set_description (d: like description)
		do
			description := d
		end

end
