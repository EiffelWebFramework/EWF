note
	description: "Summary description for {WSF_FORM_ELEMENT_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_FORM_ELEMENT_CONTROL [G]

inherit

	WSF_CONTROL

feature

	is_valid (value: G): BOOLEAN
		do
			if attached validate as v then
				Result := v.item ([value])
			else
				Result := True
			end
		end


feature

	value_control: WSF_VALUE_CONTROL[G]

	validate: detachable FUNCTION [ANY, TUPLE [G], BOOLEAN]

	

end
