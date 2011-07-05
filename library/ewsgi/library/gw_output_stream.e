note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

deferred class
	GW_OUTPUT_STREAM

feature -- Basic operation

	put_string (s: STRING_8)
		require
			s_not_empty: s /= Void and then not s.is_empty
		deferred
		end

end
