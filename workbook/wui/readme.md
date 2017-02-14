---
layout: default
title: readme
base_url: ../../../
---
# Web User Interface (WUI)

When it comes to web user interface, HTML, CSS and Javascript are part of the solution.
To generate the HTML and CSS, there are many solution, among them:
* use template (such as can use templates like the [Eiffel Smarty lib](https://github.com/EiffelSoftware/EiffelStudio/tree/master/Src/contrib/library/text/template/smarty)
* generate the html from the Eiffel code directly
* use high level components that generate the html themselves.

Within the EiffelWeb framework, the `wsf_html` library provides classes to build a structured representation of html and then generate expected HTML.


## Overview 
The [`wsf_html` library](https://github.com/EiffelWebFramework/EWF/tree/master/library/server/wsf_html) provides:

* `CSS_*` classes to generate CSS style.
* `WSF_WIDGET_*` classes representing HTML widget (such as `<table..`, raw text, pager, ..)
* and `WSF_FORM_*` classes which are also widgets, but specific to web forms (i.e `<form ..`, `<input ...`, ...).

In addition, the `WSF_FORM_..` is capable to analyze parameters from request `WSF_REQUEST` to populate its entries, but support value validation, and finally value submission. See the section "web form handling".

## Generating web form html

A simple solution to return html content is to use the `WSF_HTML_PAGE_RESPONSE` for now.
In a `WSF_EXECUTION` descendant, see how to implement the `execute` procedure.

```
	execute
		local
			mesg: WSF_HTML_PAGE_RESPONSE
		do
			create mesg.make
			mesg.set_title ("This is an HTML page")
			mesg.set_body ("<h1>HTML Response</h1>")
			response.send (mesg)
		end
```

In this case, the html is hardcoded, and written manually.
Now let's see how to use the WSF widgets on a more advanced usecase, a simple sign-in web form with 2 input fields `username`, `password` and `submit` button.

```

	execute
		do
				-- Basic url dispatching...
			if request.is_post_request_method then
				execute_web_form_submission
			else
				execute_web_form_display
			end
		end

	execute_web_form_display
		local
			mesg: WSF_HTML_PAGE_RESPONSE
			f: WSF_FORM
			l_html: STRING
		do
				-- Build the web form
			f := new_login_form 

				-- Html generation
				--| the first argument of `to_html` is the theme for advanced usage you can provide a custom theme
				--| that can redefine how to generate link for instance.
			l_html := f.to_html (create {WSF_REQUEST_THEME}.make_with_request (request))

				-- Send the response
			create mesg.make
			mesg.set_title ("This is a Web form")
			mesg.set_body (l_html)
			response.send (mesg)
		end

	execute_web_form_submission
		do
			... this will be explain in next section !
		end

	new_login_form: WSF_FORM
		local
			f: WSF_FORM
			f_set: WSF_FORM_FIELD_SET
			f_username: WSF_FORM_TEXT_INPUT
			f_password: WSF_FORM_PASSWORD_INPUT
			f_submit: WSF_FORM_SUBMIT_INPUT
		do
				-- Build the web form
			create f.make ("/form", "form-login") -- The form id is optional.
			f.set_method_post -- it could also use the default GET method.

				-- Put specific html code
			f.extend_html_text ("<h1>Web form example</h1>")

				-- username input field
			create f_username.make ("username")
			f_username.set_label ("User name")
			f.extend (f_username)

				-- password input field
			create f_password.make ("password")
			f_password.set_label ("Password")
			f.extend (f_password)

				-- submit button
			create f_submit.make_with_text ("op", "Login")
			f.extend (f_submit)

			Result := f
		end	
```

## Handling web form data

When a form is submitted, the code can access the request data thanks to the `request: WSF_REQUEST` attribute.
See [Handling requests section](../../handling_request/form)

The `wsf_html` library, thanks to the `WSF_FORM`, provides a more powerful solution.
Indeed `WSF_HTML.process (request, .., ..)` analyze the request, fill the form fields, and process various validations, and submissions automatically.

See

```
	process (req: WSF_REQUEST; a_before_callback, a_after_callback: detachable PROCEDURE [WSF_FORM_DATA])
			-- Process Current form with request `req`,
			-- and build `last_data: WSF_FORM_DATA` object containing the field values.
			-- agent `a_before_callback` is called before the validation
			-- agent `a_after_callback` is called after the validation
```

In our previous sample code, `execute_web_form_submission` could be:

```
	execute_web_form_submission
		local
			mesg: WSF_HTML_PAGE_RESPONSE
			l_html: STRING
			f: WSF_FORM
		do
			create mesg.make
			mesg.set_title ("Web form submission")
			create l_html.make_empty

				-- Build again the same form.
			f := new_login_form

				-- Process this form with `request` data.
			f.process (request, Void, Void)
			if attached f.last_data as form_data and then not form_data.has_error then
					-- `form_data` contains the submitted fields with their value.

					-- Depending on the form data, display a response.
				l_html.append ("Username: ")
				if attached form_data.string_item ("username") as l_username then
						-- The username may contain unicode, or characters like '<'
						-- thus, it needs to be html encoded
					l_html.append (mesg.html_encoded_string (l_username))
				else
					l_html.append ("missing value !!")
				end
				l_html.append ("<br/>")
				if attached form_data.string_item ("password") as l_password then
					l_html.append ("Password: ")
						-- The password may contain unicode, or characters like '<'
						-- thus, it needs to be html encoded
					l_html.append (mesg.html_encoded_string (l_password))
				else
					l_html.append ("missing value !!")
				end
				l_html.append ("<br/>")
			else
				l_html.append ("Error while processing the web form!")

					-- Display again the form (it will contain the submitted values, if any).
				f.append_to_html (create {WSF_REQUEST_THEME}.make_with_request (request), l_html)
			end
			
			mesg.set_body (l_html)
			response.send (mesg)
		end
```

In this case, the code could report an error if the username is empty, or with unwanted character ... this could be done in the `execute_web_form_submission` code, but it is also possible to set validation on each form field.
If those validations reports error, then the `form_data.has_error` will be True.

To set validation, 
For instance, in previous sample, accepts only alpha-numeric characters:

```
			f_username.set_description ("Only alpha-numeric character are accepted.")
			f_username.set_validation_action (agent (fd: WSF_FORM_DATA)
				do
					if attached fd.string_item ("username") as u then
						if across u as ic some not ic.item.is_alpha_numeric end then
							fd.report_invalid_field ("username", "Missing username value!")
						elseif u.is_whitespace then
							fd.report_invalid_field ("username", "Empty username value!")
						end
					else
						fd.report_invalid_field ("username", "Missing username value!")
					end
				end)
```

Notes:
* If the validation is not satisfied, the form data will report `has_error` as True, and the associated form will be updated with submitted values, and with `class="error"` set to the related html code.
The errors are also available via the `form_data.errors` feature.
* Since the validation feature argument is the `WSF_FORM_DATA` itself, it is also possible to validate several fields at once.

If there is no error, the form submission process will trigger the `WSF_FORM.submit_actions`. This could be used when the form is built by different components, and each component will handle the submission of its associated fields.


## Catalog of widgets
The `wsf_html` library includes a collection of widgets and form items:

### `WSF_WIDGET_...`
* `.._DIV`: `<div..>..</div>` html element.
* `.._IMAGE`: `<img .../>` html element.
* `.._RAW_TEXT`: html escaped text.
* `.._TEXT`: html text.
And more advanced widgets such as:
* `.._PAGER`: to generate pager widget like ` << 1 2 3 .. >> `
* `.._TABLE`: a set of classes to generate `<table ../>` html element.


### `WSF_FORM_...`
Widget usually included in web forms, such as
* `WSF_FORM_*_INPUT`: text, password, file, submit, ...
* `WSF_FORM_FIELD_SET`, `.._TEXTAREA` ...


## What about CSS style
The `CSS_STYLE`, `CSS_SELECTOR` and `CSS_TEXT` can be used to generate CSS style sheat, but they can also be used to set css style to `WSF_WIDGET`.


## Potential future evolutions
For now, the `wsf_html` provides a simple solution to build web form. It is always possible to add new `WSF_WIDGET` to support more html elements.
Advanced usage could be built on top of the `wsf_html` to include for instance javascript actions, but this is out of the scope of `wsf_html` .



