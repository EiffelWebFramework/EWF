note
	description: "Facilities for INTEGER_X constants"
	author: "Colin LeMahieu"
	date: "$Date: 2011-11-11 18:13:16 +0100 (ven., 11 nov. 2011) $"
	revision: "$Revision: 87787 $"
	quote: "There is no worse tyranny than to force a man to pay for what he does not want merely because you think it would be good for him. - Robert Heinlein "

deferred class
	CONSTANTS

feature
	four: INTEGER_X
		do
			create result.make_from_integer(4)
		end

	three: INTEGER_X
		do
			create result.make_from_integer(3)
		end

	two: INTEGER_X
		do
			create result.make_from_integer(2)
		end

	one: INTEGER_X
		do
			create result.make_from_integer(1)
		end

	zero: INTEGER_X
		do
			create result.default_create
		end
end
