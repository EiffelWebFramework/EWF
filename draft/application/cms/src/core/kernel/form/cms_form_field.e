note
	description: "Summary description for {CMS_FORM_ITEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_FORM_FIELD

inherit
	CMS_FORM_ITEM

	DEBUG_OUTPUT

feature -- Access

	name: READABLE_STRING_8

	label: detachable READABLE_STRING_8

	description: detachable READABLE_STRING_8

	is_required: BOOLEAN

	is_invalid: BOOLEAN

	is_readonly: BOOLEAN


feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := name + " {" + generator + "}"
		end

feature -- Validation		

	validation_action: detachable PROCEDURE [ANY, TUPLE [CMS_FORM_DATA]]
			-- Function returning True if valid, otherwise False

	validate (fd: CMS_FORM_DATA)
		do
			if attached validation_action as act then
				act.call ([fd])
			end
		end

feature -- Element change

	update_name (a_name: like name)
		require
			name.is_empty
		do
			name := a_name
		end

	set_is_required (b: BOOLEAN)
		do
			is_required := b
		end

	set_is_readonly (b: BOOLEAN)
		do
			is_readonly := b
		end

	set_label (lab: like label)
		do
			label := lab
		end

	set_description (t: like description)
		do
			description := t
		end

	set_validation_action (act: like validation_action)
		do
			validation_action := act
		end

	set_is_invalid (b: BOOLEAN)
		do
			is_invalid := b
		end

	set_value (v: detachable WSF_VALUE)
			-- Set value `v' if applicable to Current
		deferred
		end

feature -- Conversion

	to_html (a_theme: CMS_THEME): STRING_8
		local
			cl: STRING
		do
			create cl.make_empty
			if is_required then
				if not cl.is_empty then
					cl.append_character (' ')
				end
				cl.append ("required")
			end
			if is_invalid then
				if not cl.is_empty then
					cl.append_character (' ')
				end
				cl.append ("error")
			end
			create Result.make_from_string ("<div class=%""+ cl +"%">")
			if attached label as lab then
				Result.append ("<strong><label for=%""+name+"%">" + lab + "</label></strong>")
				if is_required then
					Result.append (" (<em>required</em>)")
				end
				Result.append ("<br/>%N")
			end
			Result.append (item_to_html (a_theme))
			if attached description as desc then
				Result.append ("<div class=%"description%">" + desc + "</div>")
			end
			Result.append ("</div>")
		end

	item_to_html (a_theme: CMS_THEME): STRING_8
		deferred
		end


end
