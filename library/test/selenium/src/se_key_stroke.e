note
	description: "Summary description for {SE_KEY_STROKE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SE_KEY_STROKE

inherit

	SE_KEY_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_key: STRING_32)
		require
			is_valid: keys.has (a_key)
		do
			set_key (a_key)
		ensure
		end

feature -- Access

	key: STRING_32
			-- current key

feature -- Change Element

	set_key (a_key: STRING_32)
			--Set `key' to `a_key'
		require
			is_valid: keys.has (a_key)
		do
			key := a_key
		ensure
			key_set: key = a_key
		end

end
