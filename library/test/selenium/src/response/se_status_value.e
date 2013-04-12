note
	description: "Summary description for {STATUS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SE_STATUS_VALUE
create
	make,
	make_empty

feature {NONE}-- Initialization
	make (an_os_value : SE_OS_VALUE; a_java_value :SE_JAVA_VALUE; a_build_value: SE_BUILD_VALUE )
		do
			set_os_value (an_os_value)
			set_java_value (a_java_value)
			set_build_value (a_build_value)
		end

	make_empty
		do

		end
feature -- Access
	os_value: detachable SE_OS_VALUE

	java_value : detachable SE_JAVA_VALUE

	build_value : detachable SE_BUILD_VALUE

feature -- Change Element
	set_os_value (an_os_value : SE_OS_VALUE)
		-- Set os_value with `an_os_value'
		do
			os_value := an_os_value
		end

	set_build_value (a_build_value : SE_BUILD_VALUE)
		-- Set build_value with `a_build_value'
		do
				build_value := a_build_value
		end

	set_java_value (a_java_value : SE_JAVA_VALUE)
		-- Set java_value with `a_java_value'
		do

			java_value := a_java_value
		end


end
