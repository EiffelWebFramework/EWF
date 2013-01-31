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
			to_html
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

	to_html (a_theme: CMS_THEME): STRING_8
		do
			Result := item_to_html (a_theme)
		end

	item_to_html (a_theme: CMS_THEME): STRING_8
		do
			Result := text
		end

end
