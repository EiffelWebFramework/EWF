note
	description: "Summary description for {WSF_MIME_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_MIME_HANDLER

feature -- Status report

	valid_content_type (a_content_type: READABLE_STRING_8): BOOLEAN
		deferred
		end

feature -- Execution

	handle (a_content_type: READABLE_STRING_8; req: WSF_REQUEST;
			a_vars: TABLE [WSF_VALUE, READABLE_STRING_32]; a_raw_data: detachable CELL [detachable STRING_8])
			-- Handle MIME content from request `req', eventually fill the `a_vars' (not yet available from `req')
			-- and if `a_raw_data' is attached, store any read data inside `a_raw_data'
		require
			valid_content_type: valid_content_type (a_content_type)
		deferred
		end

end
