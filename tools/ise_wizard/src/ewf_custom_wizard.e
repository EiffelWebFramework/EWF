note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	EWF_CUSTOM_WIZARD

inherit
	EWF_WIZARD
		redefine
			get_information,
			generate_project
		end

create
	make

feature -- Form

	get_information
		do
			if attached string_question ("Location of EWF source code (by default $EWF_DIR)?", Void, Void, False) as pn then
				ewf_dir := pn.string
			else
				ewf_dir := "$EWF_DIR"
			end
			Precursor
		end

feature -- Generation

	generate_project (a_layout: WIZARD_LAYOUT)
		do
			if attached ewf_dir as d then
				variables.force (d, "EWF_DIR")
				Precursor (a_layout)
			else
				die (-1)
			end
		end

feature -- Access

	ewf_dir: detachable READABLE_STRING_8

feature -- Change

feature {NONE} -- Implementation

invariant
--	invariant_clause: True 

end
