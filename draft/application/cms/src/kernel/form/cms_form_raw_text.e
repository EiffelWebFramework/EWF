note
	description: "Summary description for {CMS_FORM_RAW_TEXT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_FORM_RAW_TEXT

inherit
	CMS_WIDGET_TEXT
		rename
			set_text as set_value,
			make_with_text as make
		redefine
			append_to_html
		end

create
	make

feature -- Conversion

	append_to_html (a_theme: CMS_THEME; a_html: STRING_8)
		do
			append_item_html_to (a_theme, a_html)
		end

	append_item_html_to (a_theme: CMS_THEME; a_html: STRING_8)
		do
			a_html.append (text)
		end

end
