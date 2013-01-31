note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	CMS_FORM_DATA

inherit
	TABLE_ITERABLE [detachable WSF_VALUE, READABLE_STRING_8]

create
	make

feature {NONE} -- Initialization

	make (req: WSF_REQUEST; a_form: CMS_FORM)
			-- Initialize `Current'.
		do
			form := a_form
			create items.make (a_form.count)
			get_items (req)
			validate
		end

feature -- Access		

	form: CMS_FORM

feature -- Status

	is_valid: BOOLEAN
		do
			Result := errors = Void
		end

feature -- Access

	item (a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE
		do
			Result := items.item (a_name.as_string_8)
		end

	string_item (a_name: READABLE_STRING_GENERAL): detachable READABLE_STRING_32
		do
			if attached {WSF_STRING} item (a_name) as s then
				Result := s.value
			end
		end

	integer_item (a_name: READABLE_STRING_GENERAL): INTEGER
		do
			if attached {WSF_STRING} item (a_name) as s and then s.is_integer then
				Result := s.integer_value
			end
		end

	new_cursor: TABLE_ITERATION_CURSOR [detachable WSF_VALUE, READABLE_STRING_8]
			-- Fresh cursor associated with current structure
		do
			Result := items.new_cursor
		end

feature -- Basic operation

	validate
		do
			across
				form as f
			loop
				if attached {CMS_FORM_FIELD} f.item as l_field then
					l_field.validate (Current)
				end
			end
			if attached form.validation_action as act then
				act.call ([Current])
			end
		end

	set_fields_invalid (b: BOOLEAN; a_name: READABLE_STRING_GENERAL)
		do
			if attached form.fields_by_name (a_name) as lst then
				across
					lst as i
				loop
					i.item.set_is_invalid (b)
				end
			end
		end

	apply_to_associated_form
		do
			if attached errors as errs then
				across
					errs as e
				loop
					if attached e.item as err then
						if attached err.field as e_field then
							set_fields_invalid (True, e_field.name)
						end
					end
				end
			end
			across
				items as c
			loop
				across
					form as i
				loop
					if attached {CMS_FORM_FIELD} i.item as l_field then
						if not attached {CMS_FORM_SUBMIT_INPUT} l_field then
							if l_field.name.same_string (c.key) then
								l_field.set_value (c.item)
							end
						end
					end
				end
			end
		end

feature -- Change

	report_error (a_msg: READABLE_STRING_8)
		do
			add_error (Void, a_msg)
		ensure
			is_invalid: not is_valid
		end

	report_invalid_field (a_field_name: READABLE_STRING_8; a_msg: READABLE_STRING_8)
		require
			has_field: form.has_field (a_field_name)
		do
			if attached form.fields_by_name (a_field_name) as lst then
				across
					lst as c
				loop
					add_error (c.item, a_msg)
				end
			end
		ensure
			is_invalid: not is_valid
		end

feature {NONE} -- Implementation

	get_items (req: WSF_REQUEST)
		do
			get_form_items (req, form)
		end

	get_form_items (req: WSF_REQUEST; lst: ITERABLE [CMS_FORM_ITEM])
		local
			n: READABLE_STRING_8
			v: detachable WSF_VALUE
		do
			across
				lst as c
			loop
				if attached {CMS_FORM_FIELD} c.item as l_field then
					n := l_field.name
					v := req.form_parameter (n)
					if l_field.is_required and (v = Void or else v.is_empty) then
						add_error (l_field, "Field %"<em>" + l_field.name + "</em>%" is required")
					else
						items.force (v, n)
					end
				elseif attached {CMS_FORM_FIELD_SET} c.item as l_fieldset then
					get_form_items (req, l_fieldset)
				end
			end
		end

	add_error (a_field: detachable CMS_FORM_FIELD; a_msg: detachable READABLE_STRING_8)
		local
			err: like errors
		do
			err := errors
			if err = Void then
				create err.make (1)
				errors := err
			end
			err.force ([a_field, a_msg])
		end

	items: HASH_TABLE [detachable WSF_VALUE, READABLE_STRING_8]

feature -- Reports	

	errors: detachable ARRAYED_LIST [TUPLE [field: detachable CMS_FORM_FIELD; message: detachable READABLE_STRING_8]]

invariant

end
