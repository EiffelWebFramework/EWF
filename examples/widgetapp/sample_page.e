note
	description: "Summary description for {SAMPLE_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAMPLE_PAGE

inherit

	BASE_PAGE
		redefine
			initialize_controls
		end

create
	make

feature

	initialize_controls
		local
			n0_container: WSF_FORM_ELEMENT_CONTROL [detachable WSF_PENDING_FILE]
			n1_container: WSF_FORM_ELEMENT_CONTROL [STRING]
			n2_container: WSF_FORM_ELEMENT_CONTROL [STRING]
			n3_container: WSF_FORM_ELEMENT_CONTROL [STRING]
			n4_container: WSF_FORM_ELEMENT_CONTROL [STRING]
			n5_container: WSF_FORM_ELEMENT_CONTROL [STRING]
			cats_container: WSF_FORM_ELEMENT_CONTROL [LIST [STRING]]
			source: INCREASING_PROGRESSSOURCE
		do
			Precursor
			create form.make
			form.add_class ("form-horizontal")
				--File
			create filebox.make
			create n0_container.make ("File Upload", filebox)
			n0_container.add_validator (create {WSF_FILESIZE_VALIDATOR}.make (100000,"File must be smaller than 100KB"))
			form.add_control (n0_container)
				--Number 1
			create textbox1.make ("1")
			create n1_container.make ("Number1", textbox1)
			n1_container.add_validator (create {WSF_DECIMAL_VALIDATOR}.make ("Invalid Number"))
			n1_container.add_validator (create {OWN_VALIDATOR}.make_own)
			form.add_control (n1_container)
				--Number 2
			create textbox2.make ("2")
			create n2_container.make ("Number2", textbox2)
			n2_container.add_validator (create {WSF_DECIMAL_VALIDATOR}.make ("Invalid Number"))
			form.add_control (n2_container)
				--Flag autocomplete
			create autocompletion1.make (create {FLAG_AUTOCOMPLETION}.make)
			create n3_container.make ("Flag Autocomplete", autocompletion1)
			form.add_control (n3_container)
				--Contact autocomplete
			create autocompletion2.make (create {CONTACT_AUTOCOMPLETION}.make)
			create n4_container.make ("Contact Autocomplete", autocompletion2)
			form.add_control (n4_container)
				--Google autocomplete
			create autocompletion3.make (create {GOOGLE_AUTOCOMPLETION}.make)
			create n5_container.make ("Google Autocomplete", autocompletion3)
			form.add_control (n5_container)
				--Categories
			create cklist.make
			cklist.add_control (create {WSF_CHECKBOX_CONTROL}.make ("Network", "net"))
			cklist.add_control (create {WSF_CHECKBOX_CONTROL}.make ("Operating Systems", "os"))
			cklist.add_control (create {WSF_CHECKBOX_CONTROL}.make ("Formal Methods and Functional Programming", "fmfp"))
			create cats_container.make ("Categories", cklist)
			cats_container.add_validator (create {WSF_MIN_VALIDATOR [LIST[STRING]]}.make (1, "Choose at least one category"))
			cats_container.add_validator (create {WSF_MAX_VALIDATOR [LIST[STRING]]}.make (2, "Choose at most two category"))
			form.add_control (cats_container)
				--Button 1
			create button1.make ("Update")
			button1.set_click_event (agent handle_click)
			button1.add_class ("col-lg-offset-2")
			form.add_control (button1)
				--Button 2
			create button2.make ("Start Modal Grid")
			button2.set_click_event (agent run_modal)
			form.add_control (button2)
				--Result
			create result_html.make ("p", "")
			form.add_control (create {WSF_FORM_ELEMENT_CONTROL [STRING]}.make ("Result", result_html))
			control.add_control (form)

				--Progress bar
			control.add_control (create {WSF_BASIC_CONTROL}.make_with_body ("h4", "", "Autoincrementing progressbar"))
			create source.make
			create progress.make_with_source (source)
			source.set_control (progress)
			progress.set_isolation (true)
			control.add_control (progress)
			navbar.set_active (1)
		end

	handle_click
		local
			text: STRING
		do
			form.validate
			if form.is_valid then
				filebox.start_upload
					--progress.set_progress ((textbox1.text.to_integer_64 / textbox2.text.to_integer_64 * 100).ceiling)
				text := textbox1.text + " + " + textbox2.text + " = " + (textbox1.text.to_integer_64 + textbox2.text.to_integer_64).out
				text.append ("<ul>")
				across
					cklist.value as s
				loop
					text.append ("<li>" + s.item + "</li>")
				end
				text.append ("</ul>")
				result_html.set_html (text)
			else
				show_alert ("VALIDATION ERROR")
			end
		end

	run_modal
		do
			start_modal("/","Test Modal", true);
		end

	process
		do
		end

	button1: WSF_BUTTON_CONTROL

	button2: WSF_BUTTON_CONTROL

	filebox: WSF_FILE_CONTROL

	textbox1: WSF_INPUT_CONTROL

	textbox2: WSF_INPUT_CONTROL

	autocompletion1: WSF_AUTOCOMPLETE_CONTROL

	autocompletion2: WSF_AUTOCOMPLETE_CONTROL

	autocompletion3: WSF_AUTOCOMPLETE_CONTROL

	cklist: WSF_CHECKBOX_LIST_CONTROL

	result_html: WSF_HTML_CONTROL

	form: WSF_FORM_CONTROL

	progress: WSF_PROGRESS_CONTROL

end
