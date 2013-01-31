note
	description: "Summary description for {CMS_FORM_CHECKBOX_INPUT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_FORM_CHECKBOX_INPUT

inherit
	CMS_FORM_INPUT
		rename
			default_value as value
		redefine
			specific_input_attributes_string,
			child_to_html
		end

	CMS_FORM_SELECTABLE_ITEM
		rename
			is_selected as checked,
			set_is_selected as set_checked
		end

create
	make,
	make_with_text

feature -- Access

	checked: BOOLEAN
			-- Current <input> element should be preselected when the page loads

	input_type: STRING = "checkbox"

	text: detachable READABLE_STRING_32

feature -- Status report

	is_same_value (v: READABLE_STRING_32): BOOLEAN
		do
			Result := attached value as l_value and then v.same_string (l_value)
		end

feature -- Change

	set_text (t: detachable READABLE_STRING_32)
		do
			text := t
		end

	set_checked (b: like checked)
		do
			checked := b
		end

feature {NONE} -- Implementation

	child_to_html (a_theme: CMS_THEME): detachable READABLE_STRING_8
			-- Specific child element if any.	
			--| To redefine if needed
		do
			if attached text as t then
				Result := a_theme.html_encoded (t)
			elseif attached value as v then
				Result := a_theme.html_encoded (v)
			end
		end

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
