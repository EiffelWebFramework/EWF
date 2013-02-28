note
	description: "Summary description for {CMS_WIDGET_TEXT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_WIDGET_TEXT

inherit
	CMS_WIDGET

create
	make_with_text

feature {NONE} -- Initialization

	make_with_text (a_text: READABLE_STRING_8)
		do
			text := a_text
		end

feature -- Access

	text: READABLE_STRING_8

feature -- Change

	set_text (a_text: like text)
		do
			text := a_text
		end

feature -- Conversion

	append_to_html (a_theme: CMS_THEME; a_html: STRING_8)
		do
			a_html.append (text)
		end

end
