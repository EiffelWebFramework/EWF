note
	description: "Provides facilities to rotate integers"
	author: "Colin LeMahieu"
	date: "$Date: 2011-11-11 18:13:16 +0100 (ven., 11 nov. 2011) $"
	revision: "$Revision: 87787 $"
	quote: "The more corrupt the state, the more it legislates. - Tacitus"

deferred class
	ROTATE_FACILITIES

feature
	rotate_right_32 (in: NATURAL_32 count: INTEGER_32): NATURAL_32
		require
			count_too_small: count >= 0
			count_too_big: count <= 32
		do
			result := (in |>> count) | (in |<< (32 - count))
		ensure
			rotate_definition: result = (in |>> count) | (in |<< (32 - count))
		end

	rotate_left_32 (in: NATURAL_32 count: INTEGER_32): NATURAL_32
		require
			count_too_small: count >= 0
			count_too_big: count <= 32
		do
			result := (in |<< count) | (in |>> (32 - count))
		ensure
			rotate_definition: result = (in |<< count) | (in |>> (32 - count))
		end
end
