note
	description: "Summary description for {WSF_FORM_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_FORM_CONTROL

inherit

	WSF_MULTI_CONTROL [WSF_CONTROL]

create
	make_form_control

feature {NONE}

	make_form_control (n: STRING)
		do
			make_multi_control (n)
			tag_name := "form"
		end

feature -- Validation

	validate: BOOLEAN
		do
			Result := True
			across
				controls as c
			until
				Result = False
			loop
				-- TODO: Change generic parameter of elm from ANY to <WILDCARD> if something like that is available in Eiffel.
				-- Otherwise, check separately for STRING, LIST...
				if attached {WSF_FORM_ELEMENT_CONTROL[ANY]} c.item as elem then
					if not elem.is_valid then
						Result := False
					end
				end
			end
		end

end
