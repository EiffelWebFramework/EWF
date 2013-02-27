note
	description: "Summary description for {CMS_FORM_ITEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_FORM_ITEM

inherit
	WITH_CSS_CLASS

	WITH_CSS_STYLE

feature -- Conversion

	append_to_html (a_theme: CMS_THEME; a_html: STRING_8)
		deferred
		end

	to_html (a_theme: CMS_THEME): STRING_8
		do
			create Result.make_empty
			append_to_html (a_theme, Result)
		end

end
