note
	description: "Object that describe the OS information from the current server"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SE_OS_VALUE

create
	make,
	make_empty


feature{NONE} -- Initialization
	make ( an_architecture : STRING_32; a_name: STRING_32; a_version: STRING_32)
		do
			set_version(a_version)
			set_name (a_name)
			set_architecture (an_architecture)
		end

	make_empty
		do

		end

feature -- Access
	architecture : detachable STRING_32
		-- The current system architecture.

	name : detachable STRING_32
		-- The name of the operating system the server is currently running on: "windows", "linux", etc.

	version : detachable STRING_32
		--The operating system version.

feature -- Change Element
	set_version (a_version : STRING_32)
		-- Set version with `a_version'
		do
			version := a_version
		ensure
			version_assigned : version ~  a_version
		end


	set_name (a_name : STRING_32)
		-- Set name with `a_name'
		do
			name := a_name
		ensure
			name_assigned : name ~  a_name
		end


	set_architecture (an_architecture : STRING_32)
		-- Set architecture with `an_architecture'
		do
			architecture := an_architecture
		ensure
			architecture_assigned : architecture ~  an_architecture
		end
end
