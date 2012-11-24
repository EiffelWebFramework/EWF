note

	description: "Conforming handler for any HTTP 1.1 standard method"

	author: "Colin Adams"
	date: "$Date$"
	revision: "$Revision$"

deferred class	WSF_METHOD_HANDLER

feature -- Method

	do_method (a_req: WSF_REQUEST; a_res: WSF_RESPONSE)
			-- Respond to `a_req' using `a_res'.
		require
			a_req_not_void: a_req /= Void
			a_res_not_void: a_res /= Void
		deferred
		ensure

		end

end

