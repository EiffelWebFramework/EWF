note
	description: "Summary description for {WITH_CSS_STYLE}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WITH_CSS_STYLE

feature -- Status report

	css_style: detachable CMS_CSS_STYLE

feature -- Change

	set_css_style (a_style: like css_style)
		do
			css_style := a_style
		end

feature -- Conversion

	append_css_style_to (a_target: STRING)
		do
			if attached css_style as l_css_style then
				a_target.append (" style=%"")
				l_css_style.append_inline_to (a_target)
				a_target.append_character ('%"')
			end
		end

end
