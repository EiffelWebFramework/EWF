note
	description: "An exception when an {INTEGER_X} doesn't have a modular inverse"
	author: "Colin LeMahieu"
	date: "$Date: 2011-11-11 18:13:16 +0100 (ven., 11 nov. 2011) $"
	revision: "$Revision: 87787 $"
	quote: "Whenever they burn books they will also, in the end, burn human beings. -  Heinrich Heine (1797-1856), Almansor: A Tragedy, 1823"

class
	INVERSE_EXCEPTION

inherit
	DEVELOPER_EXCEPTION
		redefine
			internal_meaning
		end

feature
	internal_meaning: STRING = "No modular inverse"
end
