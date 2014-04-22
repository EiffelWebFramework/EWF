note
	description: "Summary description for {UPLOAD_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	UPLOAD_PAGE

inherit

	BASE_PAGE
		redefine
			initialize_controls
		end

create
	make

feature -- Implementation

	initialize_controls
		local
		do
			Precursor
			control.add_control (create {WSF_BASIC_CONTROL}.make_with_body ("h1", "", "File Upload Demo"))
			create form.make
				--File
			create filebox.make
			filebox.set_upload_function (agent upload_file)
			filebox.set_upload_done_event (agent submit_form)
			create n1_container.make ("File Upload", filebox)
			n1_container.add_validator (create {WSF_FILESIZE_VALIDATOR}.make (10000000, "File must be smaller than 10MB"))
			form.add_control (n1_container)
				--File
			create filebox2.make
			filebox2.set_upload_function (agent upload_file)
			create n2_container.make ("Auto start Upload", filebox2)
			filebox2.set_change_event (agent
				do
					n1_container.validate
					if n1_container.is_valid then
						filebox2.start_upload
					end
				end)
			n2_container.add_validator (create {WSF_FILESIZE_VALIDATOR}.make (10000000, "File must be smaller than 10MB"))
			form.add_control (n2_container)
				--Image
			create filebox3.make_with_image_preview
			filebox3.set_upload_function (agent upload_file)
			filebox3.set_upload_done_event (agent submit_form)
			create n3_container.make ("Image Upload", filebox3)
			n3_container.add_validator (create {WSF_FILESIZE_VALIDATOR}.make (10000000, "File must be smaller than 10MB"))
			form.add_control (n3_container)

				--Button 1
			create button1.make ("Update")
			button1.set_click_event (agent submit_form)
			button1.add_class ("col-lg-offset-2")
			form.add_control (button1)
			control.add_control (form)
			navbar.set_active (5)
		end

	submit_form
		do
			form.validate
			if form.is_valid then
				if attached filebox.file as f  then
					if not f.is_uploaded then
						filebox.set_disabled (true)
						filebox.start_upload
						filebox2.set_disabled (true)
						filebox3.set_disabled (true)
						filebox3.start_upload
						button1.set_disabled (true)
						button1.set_text ("Uploading ...")
					else
						button1.set_text ("Done")

					end

				end
			end
		end

	upload_file (f: ITERABLE [WSF_UPLOADED_FILE]): detachable STRING_32
		do
				-- Store file on server and return link
			across
				f as i
			loop
				Result := i.item.filename
			end
		end

	process
		do
		end

feature -- Properties

	form: WSF_FORM_CONTROL

	button1: WSF_BUTTON_CONTROL

	filebox: WSF_FILE_CONTROL

	filebox2: WSF_FILE_CONTROL

	filebox3: WSF_FILE_CONTROL

	n1_container: WSF_FORM_ELEMENT_CONTROL [detachable WSF_FILE_DEFINITION]

	n2_container: WSF_FORM_ELEMENT_CONTROL [detachable WSF_FILE_DEFINITION]

	n3_container: WSF_FORM_ELEMENT_CONTROL [detachable WSF_FILE_DEFINITION]

end
