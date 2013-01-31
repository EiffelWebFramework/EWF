note
	description : "[
			Component representing an email
			]"
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	CMS_EMAIL

create
	make

feature {NONE} -- Initialization

	make (a_from: like from_address; a_to_address: READABLE_STRING_8; a_subject: like subject; a_body: like body)
			-- Initialize `Current'.
		do
			initialize
			from_address := a_from
			subject := a_subject
			body := a_body
			to_addresses.extend (a_to_address)

		end

	initialize
		do
			create date.make_now_utc
			create to_addresses.make (1)
		end

feature -- Access

	date: DATE_TIME

	from_address: READABLE_STRING_8

	to_addresses: ARRAYED_LIST [READABLE_STRING_8]

	subject: READABLE_STRING_8

	body: READABLE_STRING_8

feature -- Change	

	set_date (d: like date)
		do
			date := d
		end

feature -- Conversion

	message: STRING_8
		do
			Result := header
			Result.append ("%N")
			Result.append (body)
			Result.append ("%N")
			Result.append ("%N")
		end

	header: STRING_8
		do
			create Result.make (20)
			Result.append ("From: " + from_address + "%N")
			Result.append ("Date: " + date_to_rfc1123_http_date_format (date) + " GMT%N")
			Result.append ("To: ")
			across
				to_addresses as c
			loop
				Result.append (c.item)
				Result.append_character (';')
			end
			Result.append_character ('%N')
			Result.append ("Subject: " + subject + "%N")
		ensure
			Result.ends_with ("%N")
		end


feature {NONE} -- Implementation

	date_to_rfc1123_http_date_format (dt: DATE_TIME): STRING_8
			-- String representation of `dt' using the RFC 1123
		do
			Result := dt.formatted_out ("ddd,[0]dd mmm yyyy [0]hh:[0]mi:[0]ss.ff2") + " GMT"
		end

invariant
--	invariant_clause: True

end
