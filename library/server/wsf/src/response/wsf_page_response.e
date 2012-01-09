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
	make,
	make_with_body

convert
	make_with_body ({READABLE_STRING_8, STRING_8, IMMUTABLE_STRING_8})

feature {NONE} -- Initialization

	make
		do
			status_code := {HTTP_STATUS_CODE}.ok
			create header.make
		end

	make_with_body (a_body: READABLE_STRING_8)
		do
			make
			body := a_body
		end

feature -- Status

	status_code: INTEGER

feature -- Header

	header: HTTP_HEADER

	body: detachable STRING_8

feature -- Output

	send_to (res: WSF_RESPONSE)
		local
			b: like body
			h: like header
		do
			h := header
			b := body
			res.set_status_code (status_code)

			if b /= Void then
				if not h.has_content_length then
					h.put_content_length (b.count)
				end
				if not h.has_content_type then
					h.put_content_type_text_plain
				end
			end
			res.put_header_text (h.string)
			if b /= Void then
				res.put_string (b)
			end
		end

end
