note
	description: "An exception when dividing by zero"
	author: "Colin LeMahieu"
	date: "$Date: 2011-11-11 18:13:16 +0100 (ven., 11 nov. 2011) $"
	revision: "$Revision: 87787 $"
	quote: "A right is not what someone gives you; it's what no one can take from you. -  Ramsey Clark, U.S. Attorney General, New York Times, 10/02/77"

class
	DIVIDE_BY_ZERO

inherit
	DEVELOPER_EXCEPTION
		redefine
			internal_meaning
		end

feature
	internal_meaning: STRING = "Divide by zero"
end
