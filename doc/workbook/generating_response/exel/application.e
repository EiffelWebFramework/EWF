note
	description : "Basic Service that show how to use common Status Code"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	WSF_DEFAULT_SERVICE
		redefine
			initialize
		end

create
	make_and_launch

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			set_service_option ("port", 9090)
		end

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the incomming request
		do
				-- To send a response we need to setup, the status code and
				-- the response headers.
			res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/csv"],["Content-Disposition","attachment;filename=Report.xls"],["Content-Length", sheet.count.out]>>)
			res.put_string (sheet)
		end

		-- ,["Content-Disposition","attachment;filename=Report.xls"]


	sheet: STRING ="[
	Q1	Q2	Q3	Q4	Total
Cherries	78	87	92	29	=SUM(B2:E2)
Grapes	77	86	93	30	=SUM(B3:E3)
	]"


end
