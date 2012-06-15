note
	description: "An exception when a {STRING} couldn't be parsed in to a {INTEGER_X}"
	author: "Colin LeMahieu"
	date: "$Date: 2011-11-11 18:13:16 +0100 (ven., 11 nov. 2011) $"
	revision: "$Revision: 87787 $"
	quote: "Heresy is only another word for freedom of thought. -  Graham Greene (1904-1991)"

class
	INTEGER_X_STRING_EXCEPTION

inherit
	DEVELOPER_EXCEPTION
		redefine
			internal_meaning
		end

feature
	internal_meaning: STRING = "Erorr parsing string as INTEGER_X"

end
