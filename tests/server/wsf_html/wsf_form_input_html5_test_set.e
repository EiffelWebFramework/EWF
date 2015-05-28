note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	WSF_FORM_INPUT_HTML5_TEST_SET

inherit
	EQA_TEST_SET

feature -- Test routines

	test_placeholder
			-- <input type="text" name="fullname"  placeholder="John Doe">
		local
			l_text_input: WSF_FORM_TEXT_INPUT
			l_theme: WSF_NULL_THEME
			l_placeholder: STRING
		do
			l_placeholder := "<div><input type=%"text%" name=%"fullname%" placeholder=%"John Doe%"/></div>"
			create l_theme.make

			create l_text_input.make ("fullname")
			l_text_input.set_placeholder ("John Doe")

			assert ("expected input with placeholder",l_text_input.to_html (l_theme).is_case_insensitive_equal_general (l_placeholder) )
		end


	test_autofocus
			-- <input type="text" name="fullname" autofocus>
		local
			l_text_input: WSF_FORM_TEXT_INPUT
			l_theme: WSF_NULL_THEME
			l_autofocus: STRING
		do
			l_autofocus := "<div><input type=%"text%" name=%"fullname%" autofocus/></div>"
			create l_theme.make

			create l_text_input.make ("fullname")
			l_text_input.enable_autofocus

			assert ("expected input with autofocus",l_text_input.to_html (l_theme).is_case_insensitive_equal_general (l_autofocus) )

			l_text_input.disable_autofocus
			l_autofocus := "<div><input type=%"text%" name=%"fullname%"/></div>"
			assert ("expected input without autofocus",l_text_input.to_html (l_theme).is_case_insensitive_equal_general (l_autofocus) )

		end


	test_autocomplete
			-- <input type="text" name="fullname" autocomplete="off">
		local
			l_text_input: WSF_FORM_TEXT_INPUT
			l_theme: WSF_NULL_THEME
			l_autocomplete: STRING
		do
			l_autocomplete := "<div><input type=%"text%" name=%"fullname%" autocomplete=%"off%"/></div>"
			create l_theme.make

			create l_text_input.make ("fullname")
			l_text_input.disable_autocomplete
			assert ("expected input with autocomplete in off",l_text_input.to_html (l_theme).is_case_insensitive_equal_general (l_autocomplete) )

			l_text_input.enable_autocomplete
			l_autocomplete := "<div><input type=%"text%" name=%"fullname%"/></div>"
			assert ("expected input without autocomplete",l_text_input.to_html (l_theme).is_case_insensitive_equal_general (l_autocomplete) )

		end

	test_required
			-- <input type="text" name="fullname" required>
		local
			l_text_input: WSF_FORM_TEXT_INPUT
			l_theme: WSF_NULL_THEME
			l_required: STRING
		do
			l_required := "<div><input type=%"text%" name=%"fullname%" required/></div>"
			create l_theme.make

			create l_text_input.make ("fullname")
			l_text_input.enable_required

			assert ("expected input with required",l_text_input.to_html (l_theme).is_case_insensitive_equal_general (l_required) )

			l_text_input.disable_required
			l_required := "<div><input type=%"text%" name=%"fullname%"/></div>"
			assert ("expected input without required",l_text_input.to_html (l_theme).is_case_insensitive_equal_general (l_required) )

		end


	test_pattern
			-- <input type="text" name="product" pattern="[0-9][A-Z]{3}"/>
		local
			l_text_input: WSF_FORM_TEXT_INPUT
			l_theme: WSF_NULL_THEME
			l_pattern: STRING
		do
			l_pattern := "<div><input type=%"text%" name=%"product%" pattern=%"[0-9][A-Z]{3}%"/></div>"
			create l_theme.make

			create l_text_input.make ("product")
			l_text_input.set_pattern ("[0-9][A-Z]{3}")

			assert ("expected input with pattern",l_text_input.to_html (l_theme).is_case_insensitive_equal_general (l_pattern) )

		end

end


