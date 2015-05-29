note
	description : "test application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_text_input: WSF_FORM_TEXT_INPUT
			l_theme: WSF_NULL_THEME
			l_input_type: WSF_FORM_SUBMIT_INPUT
			l_search_type: WSF_FORM_SEARCH_INPUT
			l_email_type: WSF_FORM_EMAIL_INPUT
			l_number_type: WSF_FORM_NUMBER_INPUT
		do


			create l_theme.make
				-- Basic example
			create l_text_input.make_with_text ("fullname", "some text example")
			print (l_text_input.to_html (l_theme))

			io.put_new_line


				-- Placeholder

			create l_text_input.make ("fullname")
			l_text_input.set_placeholder ("John Doe")
			print (l_text_input.to_html (l_theme))

			io.put_new_line

				-- autofocus
			create l_text_input.make ("fullname")
			l_text_input.enable_autofocus
			print (l_text_input.to_html (l_theme))

			io.put_new_line

				-- autocomplete
			create l_text_input.make ("fullname")
			l_text_input.disable_autocomplete
			print (l_text_input.to_html (l_theme))

			io.put_new_line

				-- required
			create l_text_input.make ("fullname")
			l_text_input.enable_required
			print (l_text_input.to_html (l_theme))

			io.put_new_line

				-- pattern
			create l_text_input.make ("product")

			l_text_input.set_pattern ("[0-9][A-Z]{3}")
			print (l_text_input.to_html (l_theme))

			io.put_new_line

				-- basic submit

			create l_input_type.make ("Submit")
			print (l_input_type.to_html (l_theme))

			io.put_new_line
				-- basic submit with formnovalidate

			create l_input_type.make ("Submit")
			l_input_type.set_formnovalidate
			print (l_input_type.to_html (l_theme))

			io.put_new_line
				-- input search
			create l_search_type.make ("Search")
			print (l_search_type.to_html (l_theme))

			io.put_new_line
				-- input email
			create l_email_type.make ("Email")
			print (l_email_type.to_html (l_theme))

			io.put_new_line
				-- input number
			create l_number_type.make ("Price")
			l_number_type.set_min (1)
			l_number_type.set_max (10)
			l_number_type.set_step (0.5)
			print (l_number_type.to_html (l_theme))


		end

end
