note
	description: "Summary description for {WSF_RESPONSE_MESSAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_RESPONSE_MESSAGE

feature -- Output

	send_to (res: WSF_RESPONSE)
		deferred
		end

end
