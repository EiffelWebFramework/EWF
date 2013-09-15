note
	description: "Summary description for {INCREASING_PROGRESSSOURCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INCREASING_PROGRESSSOURCE

inherit

	WSF_PROGRESSSOURCE

create
	make

feature {NONE} -- Initialization

	progress_value: INTEGER

	make
		do
			progress_value := 0
		end

feature -- Implementation

	progress: INTEGER
		do
			Result := progress_value
			if progress_value < 100 then
				progress_value := progress_value + 1
			end
		end

end
