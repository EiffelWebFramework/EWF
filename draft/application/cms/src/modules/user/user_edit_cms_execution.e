note
	description: "[
			]"

class
	USER_EDIT_CMS_EXECUTION

inherit
	CMS_EXECUTION

	USER_MODULE_LIB

create
	make

feature -- Execution

	process
			-- Computed response message.
		local
			b: STRING_8
			f: CMS_FORM
			fd: detachable CMS_FORM_DATA
			u, fu: detachable CMS_USER
			up: detachable CMS_USER_PROFILE
			l_is_editing_current_user: BOOLEAN
		do
			if attached {WSF_STRING} request.path_parameter ("uid") as p_uid and then p_uid.is_integer then
				u := service.storage.user_by_id (p_uid.integer_value)
				if has_permission ("view users") then
				else
					if u /= Void and then u.same_as (user) then
					else
						u := Void
					end
				end
			else
				u := user
			end
			if attached user as l_active_user then
				l_is_editing_current_user := l_active_user.same_as (u)
			end
			create b.make_empty
			initialize_primary_tabs (u)
			if u = Void then
				b.append ("Access denied")
				set_redirection (url ("/user/register", Void))
			else
				service.storage.fill_user_profile (u)
				f := edit_form (u, request.path_info, "user-edit")

				if request.is_post_request_method then
					create fd.make (request, f)
					if attached {WSF_STRING} fd.item ("username") as s_username then
						fu := service.storage.user_by_name (s_username.value)
						if fu = Void then
							fd.report_invalid_field ("username", "User does not exist!")
						end
					end
					if attached {WSF_STRING} fd.item ("email") as s_email then
						fu := service.storage.user_by_email (s_email.value)
						if fu /= Void and then fu.id /= u.id then
							fd.report_invalid_field ("email", "Email is already used by another user!")
						end
					end
					fu := Void
				end
				if fd /= Void and then fd.is_valid then
					across
						fd as c
					loop
						b.append ("<li>" +  html_encoded (c.key) + "=")
						if attached c.item as v then
							b.append (html_encoded (v.string_representation))
						end
						b.append ("</li>")
					end

					if attached {WSF_STRING} fd.item ("password") as s_password then
						u.set_password (s_password.value)
					end
					if attached {WSF_STRING} fd.item ("email") as s_email then
						u.set_email (s_email.value)
					end

					if attached {WSF_STRING} fd.item ("note") as s_note then
						up := u.profile
						if up = Void then
							create up.make
						end
						up.force (s_note.value, "note")
						u.set_profile (up)
					end

					service.storage.save_user (u)
					if l_is_editing_current_user and u /= user then
						set_user (u)
					end
					set_redirection (url ("/user", Void))
					set_main_content (b)
				else
					if fd /= Void then
						if not fd.is_valid then
							report_form_errors (fd)
						end
						fd.apply_to_associated_form
					end
					b.append (f.to_html (theme))
				end
			end
			set_main_content (b)
		end

	edit_form (u: CMS_USER; a_url: READABLE_STRING_8; a_name: STRING): CMS_FORM
		local
			f: CMS_FORM
			ti: CMS_FORM_TEXT_INPUT
			tp: CMS_FORM_PASSWORD_INPUT
			ta: CMS_FORM_TEXTAREA
			ts: CMS_FORM_SUBMIT_INPUT
		do
			create f.make (a_url, a_name)

			create ti.make ("username")
			ti.set_label ("Username")
			ti.set_default_value (u.name)
			ti.set_is_required (False)
			ti.set_is_readonly (True)
			f.extend (ti)

			f.extend (create {CMS_FORM_RAW_TEXT}.make ("<br/>"))

			create tp.make ("password")
			tp.set_label ("Password")
			tp.set_is_required (False)
			f.extend (tp)

			f.extend (create {CMS_FORM_RAW_TEXT}.make ("<br/>"))

			create ti.make ("email")
			ti.set_label ("Valid email address")
			if attached u.email as l_email then
				ti.set_default_value (l_email)
			end
			ti.set_is_required (True)
			f.extend (ti)

			f.extend (create {CMS_FORM_RAW_TEXT}.make ("<br/>"))

			create ta.make ("note")
			ta.set_label ("Additional note about you")
			ta.set_description ("You can use this input to tell us more about you")
			if attached u.profile as p and then attached p.item ("note") as l_note then
				ta.set_default_value (l_note)
			end
			ta.set_is_required (False)
			f.extend (ta)

			f.extend (create {CMS_FORM_RAW_TEXT}.make ("<br/>"))

			create ts.make ("op")
			ts.set_default_value ("Save")
			f.extend (ts)

			Result := f
		end

end
