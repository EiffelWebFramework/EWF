note
	description: "Summary description for {CMS_WIDGET_TABLE_ITEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_WIDGET_TABLE_ITEM

inherit
	CMS_WIDGET

	WITH_HTML_ATTRIBUTE

	WITH_CSS_CLASS

	WITH_CSS_STYLE

	ITERABLE [CMS_WIDGET]

create
	make_with_text,
	make_with_text_and_css,
	make_with_content

feature {NONE} -- Initialization

	make_with_text (a_text: READABLE_STRING_8)
		do
			make_with_content (create {CMS_WIDGET_TEXT}.make_with_text (a_text))
		end

	make_with_text_and_css (a_text: READABLE_STRING_8; a_css_classes: detachable ITERABLE [READABLE_STRING_8])
		do
			make_with_text (a_text)
			if a_css_classes /= Void then
				across
					a_css_classes as c
				loop
					add_css_class (c.item)
				end
			end
		end

	make_with_content (a_widget: CMS_WIDGET)
		do
			content := a_widget
		end

feature -- Access

	content: CMS_WIDGET

feature -- Access

	new_cursor: ITERATION_CURSOR [CMS_WIDGET]
			-- Fresh cursor associated with current structure
		local
			lst: ARRAYED_LIST [CMS_WIDGET]
		do
			create lst.make (1)
			lst.extend (content)
			Result := lst.new_cursor
		end

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
