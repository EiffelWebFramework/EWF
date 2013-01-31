note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	CMS_FORM_FIELD_SET

inherit
	CMS_FORM_ITEM

	ITERABLE [CMS_FORM_ITEM]

	WITH_CSS_ID

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
			create items.make (0)
		end

feature -- Access

	legend: detachable READABLE_STRING_8

feature -- Access

	new_cursor: ITERATION_CURSOR [CMS_FORM_ITEM]
			-- Fresh cursor associated with current structure
		do
			Result := items.new_cursor
		end

feature -- Change

	set_legend (v: like legend)
		do
			legend := v
		end

	extend (i: CMS_FORM_ITEM)
		do
			items.force (i)
		end

feature -- Conversion

	to_html (a_theme: CMS_THEME): STRING_8
		do
			Result := "<fieldset"
			append_css_class_to (Result, Void)
			append_css_id_to (Result)
			append_css_style_to (Result)

			Result.append (">%N")
			if attached legend as leg then
				Result.append ("<legend>" + leg + "</legend>%N")
			end
			across
				items as c
			loop
				Result.append (c.item.to_html (a_theme))
			end
			Result.append ("%N</fieldset>%N")
		end

feature {NONE} -- Implementation

	items: ARRAYED_LIST [CMS_FORM_ITEM]

end
