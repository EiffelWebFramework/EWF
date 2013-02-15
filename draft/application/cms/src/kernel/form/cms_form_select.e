note
	description: "Summary description for {CMS_FORM_SELECT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_FORM_SELECT

inherit
	CMS_FORM_FIELD

	CMS_FORM_UTILITY

create
	make

feature {NONE} -- Initialization

	make (a_name: like name)
		do
			name := a_name
			create options.make (0)
		end

feature -- Access

	options: ARRAYED_LIST [CMS_FORM_SELECT_OPTION]

feature -- Element change

	set_text_by_value (a_text: detachable READABLE_STRING_GENERAL)
		local
			opt: CMS_FORM_SELECT_OPTION
			l_found: BOOLEAN
			v: READABLE_STRING_8
		do
			if a_text /= Void then
				v := html_encoded_string (a_text.to_string_32)
				across
					options as o
				loop
					if o.item.is_same_value (v) then
						l_found := True
						o.item.set_is_selected (True)
					else
						o.item.set_is_selected (False)
					end
				end
				if not l_found then
					create opt.make (v, Void)
					opt.set_is_selected (True)
					add_option (opt)
				end
			else
				across
					options as o
				loop
					o.item.set_is_selected (False)
				end
			end
		end

	select_value_by_text (a_text: detachable READABLE_STRING_GENERAL)
		local
			l_found: BOOLEAN
			v: READABLE_STRING_8
		do
			if a_text /= Void then
				v := html_encoded_string (a_text.to_string_32)
				across
					options as o
				loop
					if o.item.is_same_text (v) then
						l_found := True
						o.item.set_is_selected (True)
					else
						o.item.set_is_selected (False)
					end
				end
			else
				across
					options as o
				loop
					o.item.set_is_selected (False)
				end
			end
		end

	set_value (v: detachable WSF_VALUE)
		do
			if attached {WSF_STRING} v as s then
				set_text_by_value (s.value)
			else
				set_text_by_value (Void)
			end
		end

	add_option (opt: CMS_FORM_SELECT_OPTION)
		do
			options.force (opt)
		end

feature -- Conversion

	item_to_html (a_theme: CMS_THEME): STRING_8
		local
			l_is_already_selected: BOOLEAN
			h: detachable STRING_8
		do
			Result := "<select name=%""+ name +"%" "
			if css_id = Void then
				set_css_id (name +"-select")
			end
			append_css_class_to (Result, Void)
			append_css_id_to (Result)
			append_css_style_to (Result)

			if is_readonly then
				Result.append (" readonly=%"readonly%" />")
			else
				Result.append ("/>")
			end

			across
				options as o
			loop
				Result.append ("<option value=%"" + o.item.value + "%" ")
--				if not l_is_already_selected then
					if
						o.item.is_selected
					then
						l_is_already_selected := True
						Result.append (" selected=%"selected%"")
					end
--				end
				Result.append (">" + o.item.text + "</option>%N")
				if attached o.item.description as d then
					if h = Void then
						create h.make_empty
					end
					h.append ("<div id=%"" + name + "-" + o.item.value + "%" class=%"option%"><strong>"+ o.item.text +"</strong>:"+ d + "</div>")
				end
			end
			Result.append ("</select>%N")
			if h /= Void then
				Result.append ("<div class=%"select help collapsible%" id=%"" + name + "-help%">" + h + "</div>%N")
			end
		end

end
