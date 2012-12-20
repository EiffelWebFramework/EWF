note
	description: "[
				The WSF_SUPPORT class is meant to handle incompatibilities between version of libraries
				And still allow to benefit from most recent improvements.

				Unicode is an example
			]"
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_SUPPORT

inherit
	ANY

	SHARED_EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

feature -- Access: environment

	starting_environment: HASH_TABLE [READABLE_STRING_GENERAL, READABLE_STRING_GENERAL]
		do
			Result := execution_environment.starting_environment_variables
		end

	environment_item (a_name: READABLE_STRING_GENERAL): detachable STRING_32
		do
			if attached execution_environment.get (a_name.to_string_8) as v then
				Result := v.to_string_32
			end
		end

end
