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
			Result := execution_environment.starting_environment
		end

end
