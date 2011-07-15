note
	description: "Summary description for {POST_REQUEST_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	POST_REQUEST_HANDLER

inherit
	GET_REQUEST_HANDLER
		redefine
			process
		end

create
	make

feature -- Execution

	process
			-- process the request and create an answer
		local
			l_data: STRING
			s: STRING
			n: INTEGER
		do
			from
				n := 1_024
				input.read_stream (n)
				s := input.last_string
				create l_data.make_empty
			until
				s.count < n
			loop
				l_data.append_string (s)
				input.read_stream (n)
			end
			Precursor
		end

end
