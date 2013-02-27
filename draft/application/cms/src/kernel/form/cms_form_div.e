note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	CMS_FORM_DIV

inherit
	CMS_FORM_ITEM

	ITERABLE [CMS_FORM_ITEM]

	WITH_CSS_ID

create
	make,
	make_with_item,
	make_with_items,
	make_with_text

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
			create items.make (0)
		end

	make_with_text (s: READABLE_STRING_8)
		do
			make_with_item (create {CMS_FORM_RAW_TEXT}.make (s))
		end

	make_with_item (i: CMS_FORM_ITEM)
		do
			create items.make (1)
			extend (i)
		end

	make_with_items (it: ITERABLE [CMS_FORM_ITEM])
		do
			create items.make (2)
			across
				it as c
			loop
				extend (c.item)
			end
		end

feature -- Access

	new_cursor: ITERATION_CURSOR [CMS_FORM_ITEM]
			-- Fresh cursor associated with current structure
		do
			Result := items.new_cursor
		end

feature -- Change

	extend (i: CMS_FORM_ITEM)
		do
			items.force (i)
		end

feature -- Conversion

	append_to_html (a_theme: CMS_THEME; a_html: STRING_8)
		do
			a_html.append ("<div")
			append_css_class_to (a_html, Void)
			append_css_id_to (a_html)
			append_css_style_to (a_html)

			a_html.append (">%N")
			across
				items as c
			loop
				c.item.append_to_html (a_theme, a_html)
			end
			a_html.append ("%N</div>%N")
		end

feature {NONE} -- Implementation

	items: ARRAYED_LIST [CMS_FORM_ITEM]

end
