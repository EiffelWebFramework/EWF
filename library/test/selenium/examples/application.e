note
	description : "project application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			execute_example1
		end

	execute_example1
		do
			(create {EXAMPLE_1}).test
		end
end
