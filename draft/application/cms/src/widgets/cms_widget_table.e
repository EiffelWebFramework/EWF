note
	description: "Summary description for {CMS_WIDGET_TABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_WIDGET_TABLE [G]

inherit
	CMS_WIDGET

	WITH_CSS_ID

	WITH_CSS_CLASS

	WITH_CSS_STYLE

create
	make

feature {NONE} -- Initialization

	make
		do
			create columns.make_empty
		end

feature -- Access

	column_count: INTEGER
		do
			Result := columns.count
		end

	columns: ARRAY [CMS_WIDGET_TABLE_COLUMN]

	column (c: INTEGER): CMS_WIDGET_TABLE_COLUMN
		do
			if c > column_count then
				set_column_count (c)
			end
			Result := columns[c]
		end

	has_title: BOOLEAN
		do
			Result := across columns as c some c.item.title /= Void end
		end

	head_data: detachable ITERABLE [G]
			-- thead

	foot_data: detachable ITERABLE [G]
			-- tfoot

	data: detachable ITERABLE [G]
			-- tbody

	compute_item_function: detachable FUNCTION [ANY, TUPLE [data: G], CMS_WIDGET_TABLE_ROW]

feature -- Change

	set_head_data (d: like head_data)
		do
			head_data := d
		end

	set_foot_data (d: like foot_data)
		do
			foot_data := d
		end

	set_data (d: like data)
		do
			data := d
		end

	set_compute_item_function (fct: like compute_item_function)
		do
			compute_item_function := fct
		end

	set_column_count (nb: INTEGER)
		do
			if nb > columns.count then
--				columns.conservative_resize_with_default (create {CMS_WIDGET_TABLE_COLUMN}, 1, nb)
				from
				until
					columns.count = nb
				loop
					columns.force (create {CMS_WIDGET_TABLE_COLUMN}.make (columns.upper + 1), columns.upper + 1)
				end
			else
				columns.remove_tail (columns.count - nb)
			end
		end

	set_column_title (c: INTEGER; t: READABLE_STRING_32)
		do
			if c > column_count then
				set_column_count (c)
			end
			if attached column (c) as col then
				col.set_title (t)
			end
		end

feature -- Conversion

	append_to_html (a_theme: CMS_THEME; a_html: STRING_8)
		local
			l_use_tbody: BOOLEAN
		do
			a_html.append ("<table")
			append_css_id_to (a_html)
			append_css_class_to (a_html, Void)
			append_css_style_to (a_html)
			a_html.append (">")

			if has_title then
				a_html.append ("<tr>")
				across
					columns as c
				loop
					c.item.append_table_header_to_html (a_theme, a_html)
				end
				a_html.append ("</tr>")
			end
			if attached head_data as l_head_data then
				l_use_tbody := True
				a_html.append ("<thead>")
				append_data_to_html (l_head_data, a_theme, a_html)
				a_html.append ("</thead>")
			end
			if attached foot_data as l_foot_data then
				l_use_tbody := True
				a_html.append ("<tfoot>")
				append_data_to_html (l_foot_data, a_theme, a_html)
				a_html.append ("</tfoot>")
			end

			if attached data as l_data then
				if l_use_tbody then
					a_html.append ("<tbody>")
				end
				append_data_to_html (l_data, a_theme, a_html)
				if l_use_tbody then
					a_html.append ("</tbody>")
				end
			end
			a_html.append ("</table>")
		end

	append_data_to_html (lst: ITERABLE [G]; a_theme: CMS_THEME; a_html: STRING_8)
		local
			fct: like compute_item_function
		do
			fct := compute_item_function
			across
				lst as d
			loop
				if fct /= Void and then attached fct.item ([d.item]) as r then
					r.append_to_html (a_theme, a_html)
				else
					a_html.append ("<tr>")
					a_html.append ("<td>")
					if attached d.item as g then
						a_html.append (g.out)
					end
					a_html.append ("</td>")
					a_html.append ("</tr>")
				end
			end
		end

end
