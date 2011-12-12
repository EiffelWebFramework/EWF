note
	description: "Summary description for {WSF_PAGE_RESPONSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_PAGE_RESPONSE

inherit
	WSF_RESPONSE_MESSAGE

create
	make

feature {NONE} -- Initialization

	make
		do
			status_code := {HTTP_STATUS_CODE}.ok
			create header.make
		end

feature -- Status

	status_code: INTEGER

feature -- Header

	header: HTTP_HEADER

	body: detachable STRING_8

feature -- Output

	send_to (res: WSF_RESPONSE)
		do
			res.set_status_code (status_code)
			res.write_header_text (header.string)
			if attached body as b then
				res.write_string (b)
			end
		end

end
