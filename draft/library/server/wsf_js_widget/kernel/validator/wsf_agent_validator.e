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
			-- Initialize with given validation function and error message
		do
			make_validator (e)
			handler := h
		ensure
			handler_set: handler = h
		end

feature -- Implementation

	is_valid (input: G): BOOLEAN
			-- Tests if given input is valid
		do
			Result := handler.item ([input])
		end

feature -- Properties

	handler: FUNCTION [ANY, TUPLE [G], BOOLEAN]
			-- The function which is used to validate inputs

end
