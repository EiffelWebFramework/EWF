note
	description: "Summary description for {WSF_AGENT_VALIDATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_AGENT_VALIDATOR [G]
inherit
	WSF_VALIDATOR [G]
create
	make_with_agent

feature {NONE} -- Initialization

	make_with_agent (h:like handler; e: STRING)
		do
			make (e)
			handler := h
		end

feature

	is_valid (input: G): BOOLEAN
		do

			Result := handler.item ( [input])
		end


	handler: FUNCTION[ANY,TUPLE[G],BOOLEAN]
end
