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

	to_html (a_theme: CMS_THEME): STRING_8
		do
			Result := "<div"
			append_css_class_to (Result, Void)
			append_css_id_to (Result)
			append_css_style_to (Result)

			Result.append (">%N")
			across
				items as c
			loop
				Result.append (c.item.to_html (a_theme))
			end
			Result.append ("%N</div>%N")
		end

feature {NONE} -- Implementation

	items: ARRAYED_LIST [CMS_FORM_ITEM]

end
