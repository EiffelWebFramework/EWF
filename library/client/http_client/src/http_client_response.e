note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	HTTP_CLIENT_RESPONSE

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
			status := 200
			raw_headers := ""
		end

feature -- Status

	error_occurred: BOOLEAN
			-- Error occurred during request

feature {HTTP_CLIENT_REQUEST} -- Status setting

	set_error_occurred (b: BOOLEAN)
			-- Set `error_occurred' to `b'
		do
			error_occurred := b
		end

feature -- Access

	status: INTEGER assign set_status

	raw_headers: READABLE_STRING_8

	headers: HASH_TABLE [READABLE_STRING_8, READABLE_STRING_8]
		local
			tb: like internal_headers
		do
			tb := internal_headers
			if tb = Void then
				create tb.make (3)
				internal_headers := tb
			end
			Result := tb
		end

	body: detachable READABLE_STRING_8 assign set_body

feature -- Change

	set_status (s: INTEGER)
		do
			status := s
		end

	set_body (s: like body)
		do
			body := s
		end

feature {NONE} -- Implementation

	internal_headers: detachable like headers

end
