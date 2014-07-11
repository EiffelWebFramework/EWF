note
	description: "Summary description for {INCREASING_PROGRESSSOURCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INCREASING_PROGRESSSOURCE

inherit

	WSF_PROGRESS_SOURCE

create
	make

feature {NONE} -- Initialization

	control: detachable WSF_PROGRESS_CONTROL

	make ()
		do
		end

feature -- Implementation

	set_control (c: WSF_PROGRESS_CONTROL)
		do
			control := c
		end

	progress: INTEGER
		do
			if attached control as c then
				Result := c.progress
				if c.progress < 100 then
					Result := Result + 1
				end
			else
				Result := 0
			end
		end

end
