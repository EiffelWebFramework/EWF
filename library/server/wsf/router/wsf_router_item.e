note
	description: "Summary description for {WSF_ROUTER_ITEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_ROUTER_ITEM

inherit
	DEBUG_OUTPUT

create
	make,
	make_with_request_methods

feature {NONE} -- Initialization

	make (m: like mapping)
		do
			mapping := m
		end

	make_with_request_methods (m: like mapping; r: like request_methods)
		do
			make (m)
			set_request_methods (r)
		end

feature	-- Access

	mapping: WSF_ROUTER_MAPPING

	request_methods: detachable WSF_ROUTER_METHODS

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			if attached {DEBUG_OUTPUT} mapping as d then
				create Result.make_from_string (d.debug_output)
			else
				create Result.make_from_string (mapping.generator)
			end
			if attached request_methods as mtds then
				Result.append_string (" [ ")
				across
					mtds as c
				loop
					Result.append_string (c.item)
					Result.append_string (" ")
				end
				Result.append_string ("]")
			end
		end

feature -- Change

	set_request_methods (r: like request_methods)
			-- Set `request_methods' to `r'
		do
			request_methods := r
		end

invariant
	mapping_attached: mapping /= Void

end
