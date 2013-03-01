note
	description: "Summary description for {CMS_WIDGET_TABLE_ITEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_WIDGET_TABLE_ITEM

inherit
	CMS_WIDGET

	WITH_CSS_CLASS

	WITH_CSS_STYLE

create
	make_with_text,
	make_with_content

feature {NONE} -- Initialization

	make_with_text (a_text: READABLE_STRING_8)
		do
			make_with_content (create {CMS_WIDGET_TEXT}.make_with_text (a_text))
		end

	make_with_content (a_widget: CMS_WIDGET)
		do
			content := a_widget
		end

feature -- Access

	content: CMS_WIDGET

feature -- Conversion

	append_to_html (a_theme: CMS_THEME; a_html: STRING_8)
		do
			a_html.append ("<td")
			append_css_class_to (a_html, Void)
			append_css_style_to (a_html)
			a_html.append_character ('>')
			content.append_to_html (a_theme, a_html)
			a_html.append ("</td>")
		end

end
