note
	description: "Summary description for {SHARED_ORDER_VALIDATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_ORDER_VALIDATION

feature
	order_validation : ORDER_VALIDATION
		once
			create Result
		end

end
