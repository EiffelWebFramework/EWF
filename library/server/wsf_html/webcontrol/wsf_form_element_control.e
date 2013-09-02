note
	description: "Summary description for {WSF_FORM_ELEMENT_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_FORM_ELEMENT_CONTROL
inherit
	WSF_CONTROL

feature

	is_valid(value: STRING):BOOLEAN
	do
		
	end

	validate: detachable FUNCTION[ANY, TUPLE[STRING], BOOLEAN]

end
