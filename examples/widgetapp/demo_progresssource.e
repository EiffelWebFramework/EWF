note
	description: "Summary description for {DEMO_PROGRESSSOURCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEMO_PROGRESSSOURCE

inherit

	WSF_PROGRESSSOURCE

create
	make

feature {NONE} -- Initialization

	make
		do
			prog := 20
		end

feature -- Implementation

	progress: INTEGER
		do
			if prog < 100 then
				prog := prog + 1
			end
			Result := prog
		end

	prog: INTEGER

end
