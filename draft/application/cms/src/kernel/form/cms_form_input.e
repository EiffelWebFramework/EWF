note
	description: "Summary description for {CMS_FORM_INPUT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_FORM_INPUT

inherit
	CMS_FORM_FIELD

feature {NONE} -- Initialization

	make (a_name: like name)
		do
			name := a_name
		end

	make_with_text (a_name: like name; a_text: READABLE_STRING_32)
		do
			make (a_name)
			set_text_value (a_text)
		end

feature -- Access

	default_value: detachable READABLE_STRING_32

	size: INTEGER
			-- Width, in characters, of an <input> element.

	maxlength: INTEGER
			-- Maximum number of characters allowed in an <input> element.

	disabled: BOOLEAN
			-- Current <input> element should be disabled?

	input_type: STRING
		deferred
		end

feature -- Element change

	set_text_value (s: detachable READABLE_STRING_32)
		do
			set_default_value (s)
		end

	set_size (i: like size)
		do
			size := i
		end

	set_maxlength (i: like maxlength)
		do
			maxlength := i
		end

	set_disabled (b: like disabled)
		do
			disabled := b
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
			Result := "<input type=%""+ input_type +"%" name=%""+ name +"%""
			append_css_class_to (Result, Void)
			append_css_id_to (Result)
			append_css_style_to (Result)

			if is_readonly then
				Result.append (" readonly=%"readonly%"")
			end
			if attached default_value as dft then
				Result.append (" value=%"" + a_theme.html_encoded (dft) + "%"")
			end
			if disabled then
				Result.append (" disabled=%"disabled%"")
			end
			if size > 0 then
				Result.append (" size=%"" + size.out + "%"")
			end
			if maxlength > 0 then
				Result.append (" maxlength=%"" + maxlength.out + "%"")
			end

			if attached specific_input_attributes_string as s then
				Result.append_character (' ')
				Result.append (s)
			end
			if attached child_to_html (a_theme) as s then
				Result.append (">")
				Result.append (s)
				Result.append ("</input>")
			else
				Result.append ("/>")
			end
		end

feature {NONE} -- Implementation

	child_to_html (a_theme: CMS_THEME): detachable READABLE_STRING_8
			-- Specific child element if any.	
			--| To redefine if needed
		do
		end

	specific_input_attributes_string: detachable STRING_8
			-- Specific input attributes if any.	
			--| To redefine if needed
		do
		end

end
