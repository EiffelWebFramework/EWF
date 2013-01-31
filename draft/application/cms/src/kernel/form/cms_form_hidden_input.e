note
	description: "Summary description for {CMS_FORM_INPUT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_FORM_HIDDEN_INPUT

inherit
	CMS_FORM_INPUT
		redefine
			input_type,
			item_to_html
		end

create
	make,
	make_with_text

feature -- Access

	input_type: STRING
		once
			Result := "hidden"
		end

feature -- Conversion

	item_to_html (a_theme: CMS_THEME): STRING_8
		do
			Result := "<div style=%"display:none%">"
			Result.append (Precursor (a_theme))
			Result.append ("</div>")
		end

end
