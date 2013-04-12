note
	description: "Object that describe the build information from the current server"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SE_BUILD_VALUE

create
	make,
	make_empty

feature{NONE} -- Initialization
	make ( a_version : STRING_32; a_revision: STRING_32; a_time: STRING_32)
		do
			set_version(a_version)
			set_revision (a_revision)
			set_time (a_time)
		end

	make_empty
		do

		end

feature -- Access
	version : detachable STRING_32
		-- A generic release label (i.e. "2.0rc3")

	revision : detachable STRING_32
		--The revision of the local source control client from which the server was built

	time : detachable STRING_32
		--A timestamp from when the server was built.

feature -- Change Element
	set_version (a_version : STRING_32)
		-- Set version with `a_version'
		do
			version := a_version
		ensure
			version_assigned : version ~  a_version
		end


	set_revision (a_revision : STRING_32)
		-- Set revision with `a_revision'
		do
			revision := a_revision
		ensure
			revision_assigned : revision ~  a_revision
		end


	set_time (a_time : STRING_32)
		-- Set time with `a_time'
		do
			time := a_time
		ensure
			time_assigned : time ~  a_time
		end
end
