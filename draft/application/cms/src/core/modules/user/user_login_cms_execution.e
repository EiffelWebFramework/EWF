note
	description: "[
			]"

class
	USER_LOGIN_CMS_EXECUTION

inherit
	CMS_EXECUTION

	CMS_AUTH_ENGINE

create
	make

feature -- Status

	valid_credential (u,p: READABLE_STRING_32): BOOLEAN
		do
			if attached service.storage.user_by_name (u) as l_user then
				Result := attached l_user.encoded_password as l_pass and then l_pass.same_string (service.storage.encoded_password (p))
			end
		end

feature -- Execution

	process
			-- Computed response message.
		local
			auth_engine: CMS_AUTH_ENGINE
			l_url: detachable READABLE_STRING_8
			err: detachable STRING_8
			b: STRING_8
			u: detachable STRING_32
		do
			if request.is_request_method ("post") then
				if
					attached {WSF_STRING} request.form_parameter (form_login_name) as s_login and then not s_login.is_empty and
					attached {WSF_STRING} request.form_parameter (form_password_name) as s_passwd and then not s_passwd.is_empty
				then
					auth_engine := Current
					u := s_login.value
					if attached service.storage.user_by_name (u) as l_user and auth_engine.valid_credential (u, s_passwd.value) then
						login (l_user, request)
					else
						err := "Authentication failed for [" + html_encoded (u) + "]"
					end
					if attached {WSF_STRING} request.form_parameter ("form-destination") as s_dest then
						l_url := request.script_url (s_dest.value)
					end
				end
			else
				if
					attached {WSF_STRING} request.item ("destination") as s_dest
				then
					l_url := request.script_url (s_dest.value)
				end
			end

			if l_url = Void then
				l_url := request.script_url ("/user")
			end

			if authenticated then
				set_redirection (l_url)
				set_title ("Login")
				create b.make_empty
				b.append ("<h1>Login</h1>%N")
				set_main_content (b)
			else
				set_title ("Login")
				create b.make_empty
				b.append ("<h1>Login</h1>%N")

				if err /= Void then
					b.append ("<div id=%"error-box%" style=%"background-color: #fcc; color:#f00;%">" + err + "</div>")
				end

				b.append ("<form action=%"" + request.path_info + "%" method=%"POST%" id=%"form-login%" style=%"border: dotted 1px #099; display: inline-block; padding: 10px; margin: 10px;%">%N")
--				b.append ("<div style=%"display:none%"><input type=%"hidden%" name=%"form-login-token%" value=%""+ cms.session.uuid +"%"></div>")
				b.append ("<div style=%"display:none%"><input type=%"hidden%" name=%"form-destination%" value=%""+ l_url +"%"></div>")
				b.append ("<div class=%"required username%">")
				b.append ("<strong><label for=%"id_username%">Username or email</label></strong> <em>(required)</em><br/>")
				b.append ("<input type=%"text%" id=%"id_username%" autofocus=%"autofocus%" name=%"" + form_login_name + "%" ")
				if u /= Void then
					b.append (" value=%""+ html_encoded (u) +"%" ")
				end
				b.append ("/>")
				b.append ("</div>")
				b.append ("<div class=%"required password%">")
				b.append ("<strong><label for=%"id_password%">Password</label></strong> <em>(required)</em><br/>")
				b.append ("<input type=%"password%" id=%"id_password%" name=%"" + form_password_name + "%" />")
				b.append ("</div>")

				b.append ("<p class=%"description%"><a href=%"" + url ("/user/password", Void) + "%" tabindex=%"-1%">Reset password</a></p>%N")

				b.append ("<div class=%"submit%">")
				b.append ("<input type=%"submit%" value=%"Log in%" name=%"submit%" >%N")
				b.append ("[
					<img alt="login" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAHiQAAB4kB+XNYvQAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAASmSURBVGiB1ZpbaBxVGMd/Mzu5bSRJY6LubmKJl4J9qShdwdpGGxGlharJSwpVVFrUUF+iT1VEUYRgaEGqsa2FGtu8xNtDsBQi5EFBS8UnsYWUtpsmaqppIdkkm+4eH77ZzWazl7lllv7gPOycmXP+/9kzM+d839GUUnjEOqAL2A7cCdSYJWjWx4F5s/wN/AgMAzNedK65NHI38CKwAwiZpcLitUvAlFlGgBPAFadCnBppAQ4DDwNhQHMqwEQBk8A5oAeYsNuAXSP1QD/wFNBqtzOLxIAzQC9ww/JVSimrZbdSalwplVJrT8rsa7dVfVZNHFRKTftgIJdps++SGksNrSDwLbAFqHUxXNwwB/wEPIe8+fJSzEi12cCDgO61OpukgN+RG7qQ74RiRkaApylg4sj4YZLqpgcalwloBvvu7SlUnQJOI6/6VRQy8jHwKkWG04aRMIlUwp7SElTqlVzYMVnslDlgAHgztyLf3e5GPnLleiaKUYto686tyDXSCHwANPkgyilNiMbG7INGzkn9QJvdltdVNnJg43uOVH34x7vMJP6ze1kbovWl9IFsI+uBJ3Ew3QgGaulqXfVvW+Lg+T5msG1EQ7SuBy7DyqH1GTKHulVoQTQDy0YiwKayyHHHJkR7xsgLyBTcFYupRbdN2CWEaM8Y2Yn7qTjHLw4w9s+o22bsoCHa0YEGZE3hmsXkInvP7vHbTBhoMJDlacTu1fs39JJMJQGoq6jLHE+kEuw9u4ejmwdpv6PDI61FiQBdBtCB9eVphv339xas89lMBdCh48FDno+0GZ+GWchAIh0F+f7q15y6fMJSaxPx2IrfPv4zNQbL4Zq8TM5P8Mu/PzvuwSczQZ0SRrzAh2EW9G3lp6Ghaa4/VQXRKbIO9ooqvYqj0UG2NW9fqy7iBiWMhGtaeOT2Ry21NhGPcXV+5QNfpVdxLPoVW5ufcKzSAnEDicUWZFekk12RTkutHTrfx6ELfZnfYuIkW5sfdyPSCvMGEnv1nOpANcc2n+Sx5va1aD6XKQMYBTqx+XXv//MjbqolAOoqGnjtvjcydT6bWAJGDSS0/w4SWbfM5+OfZKIokZrWjJHqQDVfRE+xpWmbt3ILMwUM68B1PBpeNUaQ49EhP02AaL+eXrN/A0RxuSZ5uW0fFXqlW2F2UIj2zMJqEMlPuMJnEyCaB2HZyBSSZLnVOIf5WGRPUXpwkfoqA1cQzcDKuNYEkil6BZvPSjw5x3BsyJGaeHLOyWUK0ZpJ0eUGseuB34B7SrVUpiB2movAQ2Sl5nJnvzeAt4Fpz9R5zzSicUV+Md80fghJFc/6IMous4i2VeM4N4id5i3gASTRE8h3woGN769JoqcISWDM1LaKUqm3MSSXnteMjySRV207BVJvxVaIC+aFpynvMJs1NRQ0AaWTnAtISHIAuOaZNOtcM/veSRETgK0NA91KqUvKvw0Dl8w+Pd0wkC71SqkjSqnYGpqImX3U29HmdFNNCPgUmTGH8GZTzRTwK/A6DpYVbrc53YXkJ55FouJh7G1zmjTLd8CXwF9Ohbg1ks1twPPAM8i/FCT/xrM4csd/QNYSnrwR/wfI5AekDWyX2QAAAABJRU5ErkJggg=="
						style="float:right; margin: 5px;"/>
					]")
				b.append ("</div>")
				b.append ("<p>Need an account? <a href=%"" + url ("/user/register", Void) + "%">Sign up now!</a></p>%N")
				b.append ("</form>%N")

				set_main_content (b)
			end
		end

	form_login_name: STRING = "login"
	form_password_name: STRING = "password"

end
