note
	description: "[
			]"

class
	USER_NEW_PASSWORD_CMS_EXECUTION

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
			u: detachable CMS_USER
			fd: detachable CMS_FORM_DATA
			e: detachable CMS_EMAIL
			l_uuid: UUID
		do
			set_title ("Request new password")
			create b.make_empty
			if not request.is_post_request_method and authenticated then
				u := user
				initialize_primary_tabs (u)
				if u /= Void then
					if attached u.email as l_email then
						f := new_password_form (request.path_info, "new-password")
						b.append ("Password reset instructions will be mailed to <em>" + l_email + "</em>. You must " +  link ("log out", "/user/logout", Void)  + " to use the password reset link in the e-mail.")
						b.append (f.to_html (theme))
					else
						b.append ("Your account does not have any email address set!")
						set_redirection (url ("/user/"+ u.id.out +"/edit", Void))
					end
				else
					b.append ("Unexpected issue")
				end
			else
				f := new_password_form (request.path_info, "new-password")
				if request.is_post_request_method then
					create fd.make (request, f)
					if attached {WSF_STRING} fd.item ("name") as s_name then
						u := service.storage.user_by_name (s_name.value)
						if u = Void then
							u := service.storage.user_by_email (s_name.value)
							if u = Void then
								fd.report_invalid_field ("name", "Sorry, " + html_encoded (s_name.value)+ " is not recognized as a user name or an e-mail address.")
							end
						end
					end
				end
				initialize_primary_tabs (u)
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
					if u /= Void and then attached u.email as l_mail_address then
						l_uuid := (create {UUID_GENERATOR}).generate_uuid
						e := new_password_email (u, l_mail_address, l_uuid.out)
						u.set_data_item ("new_password_extra", l_uuid.out)
						service.storage.save_user (u)
						service.mailer.safe_process_email (e)
						add_success_message ("Further instructions have been sent to your e-mail address.")
						set_redirection (url ("/user", Void))
					end
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

	new_password_form (a_url: READABLE_STRING_8; a_name: STRING): CMS_FORM
		require
			attached user as l_auth_user implies l_auth_user.has_email
		local
			u: like user
			f: CMS_FORM
			ti: CMS_FORM_TEXT_INPUT
			th: CMS_FORM_HIDDEN_INPUT
			ts: CMS_FORM_SUBMIT_INPUT
			err: BOOLEAN
		do
			create f.make (a_url, a_name)
			u := user
			if u = Void then
				create ti.make ("name")
				ti.set_label ("Username or e-mail address")
				ti.set_is_required (True)
				f.extend (ti)
			elseif attached u.email as l_mail then
				create th.make ("name")
				th.set_default_value (l_mail)
				th.set_is_required (True)
				f.extend (th)
			else
				f.extend_text ("The associated account has no e-mail address.")
				err := True
			end

			if not err then
				create ts.make ("op")
				ts.set_default_value ("E-mail new password")
				f.extend (ts)
			end

			Result := f
		end

	new_password_email (u: CMS_USER; a_mail_address: STRING; a_extra: READABLE_STRING_8): CMS_EMAIL
		local
			b: STRING
			opts: CMS_URL_API_OPTIONS
			dt: detachable DATE_TIME
		do
			create b.make_empty
			create opts.make_absolute

			b.append ("A request to reset the password for your account has been made at " + service.site_name + ".%N")
			b.append ("You may now log in by clicking this link or copying and pasting it to your browser:%N%N")
			dt := u.last_login_date
			if dt = Void then
				dt := u.creation_date
			end
			b.append (url ("/user/reset/" + u.id.out + "/" + unix_timestamp (dt).out + "/" + a_extra, opts))
			b.append ("%N")
			b.append ("%N")
			b.append ("This link can only be used once to log in and will lead you to a page where you can set your password. It expires after one day and nothing will happen if it's not used.%N")
			b.append ("%N%N-- The %"" + service.site_name + "%" team")

			create Result.make (service.site_email, a_mail_address, "Account details for " + u.name + " at " + service.site_name, b)
		end

end
