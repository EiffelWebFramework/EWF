note
	description:"[
		This class is only used because the code viewer has a specific
		mapping in javascript. The Eiffel class does not provide
		special functionality itself.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_CODEVIEW_CONTROL

inherit

	WSF_TEXTAREA_CONTROL
		rename
			make as make_codeview
		end

create
	make_codeview

end
