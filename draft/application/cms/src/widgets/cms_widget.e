note
	description: "Summary description for {CMS_WIDGET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_WIDGET

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
