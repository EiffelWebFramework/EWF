note
	description: "Summary description for {CODEVIEW_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CODEVIEW_PAGE

inherit

	WSF_PAGE_CONTROL
		redefine
			control
		end
create
	make

feature

	initialize_controls
		do
			create control.make_codeview ("textarea", "")
		end

	process
			-- Function called on page load (not on callback)
		local
			l_file: PLAIN_TEXT_FILE
			l_content: STRING
		do
			if attached get_parameter ("file") as f then
				create l_file.make_open_read ("./"+f+".e")
				l_file.read_stream (l_file.count)
				l_content := l_file.last_string.twin
				l_file.close
				control.set_text (l_content)
			end
		end

feature

	control: WSF_CODEVIEW_CONTROL

end
