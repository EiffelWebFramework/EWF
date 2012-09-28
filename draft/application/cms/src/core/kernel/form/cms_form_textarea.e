note
	description: "Summary description for {CMS_FORM_INPUT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_FORM_TEXTAREA

inherit
	CMS_FORM_FIELD

create
	make

feature {NONE} -- Initialization

	make (a_name: like name)
		do
			name := a_name
		end

feature -- Access

	default_value: detachable READABLE_STRING_GENERAL

	rows: INTEGER

	cols: INTEGER

feature -- Element change

	set_rows (i: like rows)
		do
			rows := i
		end

	set_cols (i: like cols)
		do
			cols := i
		end

	set_text_value (s: like default_value)
		do
			set_default_value (s)
		end

	set_value (v: detachable WSF_VALUE)
		do
			if attached {WSF_STRING} v as s then
				set_text_value (s.value)
			else
				set_text_value (Void)
			end
		end

	set_default_value (v: like default_value)
		do
			default_value := v
		end

feature -- Conversion

	item_to_html (a_theme: CMS_THEME): STRING_8
		do
			Result := "<textarea name=%""+ name +"%""
			if rows > 0 then
				Result.append (" rows=%"" + rows.out + "%"")
			end
			if cols > 0 then
				Result.append (" cols=%"" + cols.out + "%"")
			end

			if is_readonly then
				Result.append (" readonly=%"readonly%">")
			else
				Result.append (">")
			end
			if attached default_value as dft then
				Result.append (a_theme.html_encoded (dft))
			end
			Result.append ("</textarea>")
		end

end
