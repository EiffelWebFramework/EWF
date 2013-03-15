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
			append_item_to_html
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

	append_item_to_html (a_theme: CMS_THEME; a_html: STRING_8)
		do
			a_html.append ("<div style=%"display:none%">")
			Precursor (a_theme, a_html)
			a_html.append ("</div>")
		end

end
