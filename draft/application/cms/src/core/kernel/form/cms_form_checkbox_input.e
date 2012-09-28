note
	description: "Summary description for {CMS_FORM_CHECKBOX_INPUT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_FORM_CHECKBOX_INPUT

inherit
	CMS_FORM_INPUT
		redefine
			specific_input_attributes_string
		end

create
	make

feature -- Access

	checked: BOOLEAN
			-- Current <input> element should be preselected when the page loads

	input_type: STRING = "checkbox"

feature -- Change

	set_checked (b: like checked)
		do
			checked := b
		end

feature {NONE} -- Implementation

	specific_input_attributes_string: detachable STRING_8
			-- Specific input attributes if any.	
			-- To redefine if needed
		do
			if checked then
				Result := "checked=%"checked%""
			end
		end

invariant

end
