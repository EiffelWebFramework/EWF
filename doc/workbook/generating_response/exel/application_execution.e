note
	description : "Basic Service that show how to use common Status Code"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION_EXECUTION

inherit
	WSF_EXECUTION

create
	make

feature -- Basic operations

	execute 
			-- Execute the incomming request
		do
				-- To send a response we need to setup, the status code and
				-- the response headers.
			response.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/csv"],["Content-Disposition","attachment;filename=Report.xls"],["Content-Length", sheet.count.out]>>)
			response.put_string (sheet)
		end

		-- ,["Content-Disposition","attachment;filename=Report.xls"]


	sheet: STRING ="[
	Q1	Q2	Q3	Q4	Total
Cherries	78	87	92	29	=SUM(B2:E2)
Grapes	77	86	93	30	=SUM(B3:E3)
	]"


end
