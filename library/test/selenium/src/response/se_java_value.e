note
	description: "Object that describe the current verion of Java"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SE_JAVA_VALUE

create
	make,
	make_empty

feature -- Initialization
	make ( a_version : STRING_32)
		do
			set_version (a_version)
		end
	make_empty
		do

		end

feature	-- Access	
	version : detachable STRING_32
		-- current Java version

feature -- Change Element
	set_version (a_version: STRING_32)
			--Set version with `a_version'
		do
			version := a_version
		ensure
			version_assigned : version ~ a_version
		end
end
