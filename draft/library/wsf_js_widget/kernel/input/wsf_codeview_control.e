note
	description: "Summary description for {WSF_CODEVIEW_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_CODEVIEW_CONTROL

inherit
	WSF_TEXTAREA_CONTROL
		rename
			make_textarea as make_codeview
		end
create
	make_codeview
end
