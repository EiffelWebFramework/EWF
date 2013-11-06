note
	description: "Summary description for {WSF_FORM_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_FORM_CONTROL

inherit

	WSF_STATELESS_MULTI_CONTROL [WSF_CONTROL]
		rename
			make as make_multi_control
		end

	WSF_VALIDATABLE

create
	make

feature {NONE} -- Initialization

	make (n: STRING)
			-- Initialize
		do
			make_multi_control (n)
			tag_name := "form"
		end

feature -- Validation

	validate
			-- Perform form validation
		do
			is_valid := True
			across
				controls as c
			until
				is_valid = False
			loop
				if attached {WSF_VALIDATABLE} c.item as elem then
					elem.validate
					if not elem.is_valid then
						is_valid := False
					end
				end
			end
		end

	is_valid: BOOLEAN
			-- Tells whether the last validation was valid

end
