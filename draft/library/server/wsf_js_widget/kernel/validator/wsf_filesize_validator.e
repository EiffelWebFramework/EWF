note
	description: "[
		Validator implementation which make sure that the uploaded file is smaller than x bytes
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_FILESIZE_VALIDATOR

inherit

	WSF_VALIDATOR [detachable WSF_FILE_DEFINITION]
		rename
			make as make_validator
		redefine
			state
		end

create
	make

feature {NONE} -- Initialization

	make (m: INTEGER; e: STRING_32)
			-- Initialize with specified maximum filesize and error message which will be displayed on validation failure
		do
			make_validator (e)
			max := m
		end

feature -- Implementation

	is_valid (a_input: detachable WSF_FILE_DEFINITION): BOOLEAN
		do
			Result := a_input /= Void implies a_input.size < max
		end

feature -- State

	state: WSF_JSON_OBJECT
		do
			Result := Precursor
			Result.put_integer (max, "max")
		end

feature -- Access

	max: INTEGER
			-- The maximal allowed value

;note
	copyright: "2011-2014, Yassin Hassan, Severin Munger, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
