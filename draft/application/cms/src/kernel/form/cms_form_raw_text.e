note
	description: "Summary description for {CMS_FORM_RAW_TEXT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_FORM_RAW_TEXT

inherit
	CMS_FORM_ITEM
		redefine
			append_to_html
		end

create
	make

feature {NONE} -- Initialization

	make (a_text: like text)
		do
			text := a_text
		end

feature -- Access

	text: READABLE_STRING_8

feature -- Element change

	set_value (v: detachable WSF_VALUE)
		do
			-- Not applicable
		end

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
