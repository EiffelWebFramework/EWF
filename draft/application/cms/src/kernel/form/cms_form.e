note
	description: "Summary description for {CMS_FORM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_FORM

inherit
	CMS_FORM_COMPOSITE

create
	make

feature {NONE} -- Initialization

	make (a_action: READABLE_STRING_8; a_id: READABLE_STRING_8)
		do
			action := a_action
			id := a_id
			initialize_with_count (10)
			create html_classes.make (2)
			set_method_post
			create validation_actions
			create submit_actions
		end

feature -- Access

	action: READABLE_STRING_8
			-- URL for the web form

	id: READABLE_STRING_8
			-- Id of the form

	is_get_method: BOOLEAN
		do
			Result := method.same_string ("GET")
		end

	is_post_method: BOOLEAN
		do
			Result := not is_get_method
		end

	method: READABLE_STRING_8
			-- Form's method
			--| GET or POST

feature -- Basic operation

	prepare (a_execution: CMS_EXECUTION)
		do
			a_execution.service.call_form_alter_hooks (Current, Void, a_execution)
		end

	process (a_execution: CMS_EXECUTION)
		local
			fd: CMS_FORM_DATA
		do
			create fd.make (a_execution.request, Current)
			last_data := fd
			a_execution.service.call_form_alter_hooks (Current, fd, a_execution)
			fd.validate
			fd.apply_to_associated_form -- Maybe only when has error?
			if fd.is_valid then
				fd.submit
				if fd.has_error then
					a_execution.report_form_errors (fd)
				end
			else
				a_execution.report_form_errors (fd)
			end
		end

	last_data: detachable CMS_FORM_DATA

feature -- Validation

	validation_actions: ACTION_SEQUENCE [TUPLE [CMS_FORM_DATA]]
			-- Procedure to validate the data
			-- report error if not valid

	submit_actions: ACTION_SEQUENCE [TUPLE [CMS_FORM_DATA]]
			-- Submit actions

feature -- Element change

	set_method_get
		do
			method := "GET"
		end

	set_method_post
		do
			method := "POST"
		end

feature -- Optional

	html_classes: ARRAYED_LIST [STRING_8]

feature -- Conversion

	append_to_html (a_theme: CMS_THEME; a_html: STRING_8)
		local
			s: STRING_8
		do
			a_html.append ("<form action=%""+ action +"%" id=%""+ id +"%" method=%""+ method +"%" ")
			if not html_classes.is_empty then
				create s.make_empty
				across
					html_classes as cl
				loop
					if not s.is_empty then
						s.extend (' ')
					end
					s.append (cl.item)
				end
				a_html.append (" class=%"" + s + "%" ")
			end
			a_html.append (">%N")
			across
				items as c
			loop
				c.item.append_to_html (a_theme, a_html)
			end
			a_html.append ("</form>%N")
		end

	to_html (a_theme: CMS_THEME): STRING_8
		do
			create Result.make_empty
			append_to_html (a_theme, Result)
		end

end
