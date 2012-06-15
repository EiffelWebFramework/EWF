note
	description: "Summary description for {ARRAY_DER_SOURCE}."
	author: ""
	date: "$Date: 2011-11-11 18:13:16 +0100 (ven., 11 nov. 2011) $"
	revision: "$Revision: 87787 $"

class
	ARRAY_DER_SOURCE

inherit
	DER_OCTET_SOURCE

create
	make

feature
	make (source_a: ARRAY [NATURAL_8])
		do
			source := source_a
		end

feature
	has_item: BOOLEAN
		do
			result := source.valid_index (current_index)
		end

	item: NATURAL_8
		do
			result := source [current_index]
		end

	process
		do
			current_index := current_index + 1
		end

feature {NONE}
	current_index: INTEGER_32
	source: ARRAY [NATURAL_8]

invariant
	source.valid_index (current_index) or current_index = source.upper + 1
end
