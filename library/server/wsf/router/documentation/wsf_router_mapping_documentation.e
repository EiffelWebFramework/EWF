note
	description: "Summary description for {WSF_ROUTER_MAPPING_DOCUMENTATION}."
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_ROUTER_MAPPING_DOCUMENTATION

create
	make

feature {NONE} -- Initialization

	make (m: like mapping)
		do
			mapping := m
			create {STRING_32} description.make_empty
		end

feature -- Status report

	is_hidden: BOOLEAN
			-- Hide this mapping from any self documentation?		
			-- Default=False

	is_empty: BOOLEAN
			-- Is Current empty?
			-- i.e: does not carry any information.
		do
			Result := description.is_empty
		end

feature -- Access

	mapping: WSF_ROUTER_MAPPING
			-- Associated mapping

	description: STRING_32

feature -- Change

	set_is_hidden (b: BOOLEAN)
		do
			is_hidden := b
		end

	add_description (d: READABLE_STRING_GENERAL)
		do
			description.append_string_general (d)
		end

end
