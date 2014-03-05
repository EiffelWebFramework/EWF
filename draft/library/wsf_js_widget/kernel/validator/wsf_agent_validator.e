note
	description: "[
		Wrapper whit which a agent can be used as validator
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_AGENT_VALIDATOR [G]

inherit

	WSF_VALIDATOR [G]
		rename
			make as make_validator
		end

create
	make

feature {NONE} -- Initialization

	make (h: like handler; e: STRING_32)
		do
			make_validator (e)
			handler := h
		end

feature

	is_valid (input: G): BOOLEAN
		do
			Result := handler.item ([input])
		end

	handler: FUNCTION [ANY, TUPLE [G], BOOLEAN]

end
