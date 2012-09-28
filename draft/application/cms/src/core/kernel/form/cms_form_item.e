note
	description: "Summary description for {CMS_FORM_ITEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_FORM_ITEM

feature -- Conversion

	to_html (a_theme: CMS_THEME): STRING_8
		deferred
		end

end
