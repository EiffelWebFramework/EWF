note
	description: "Summary description for {REST_RESPONSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REST_RESPONSE

create
	make

feature {NONE} -- Initialization

	make (a_api: like api)
		do
			api := a_api
			initialize
		end

	initialize
		do
			create headers.make
		end

feature -- Recycle

	recycle
		do
			headers.recycle
		end

feature -- Access

	headers: HTTP_HEADER

	api: STRING
			-- Associated api query string.

	message: detachable STRING_8
			-- Associated message to send with the response.

feature -- Element change

	set_message (m: like message)
			-- Set `message' to `m'
		do
			message := m
		end

	append_message (m: attached like message)
			-- Append message `m' to current `message' value
			-- create `message' is Void
		require
			m_not_empty: m /= Void and then not m.is_empty
		do
			if attached message as msg then
				msg.append (m)
			else
				set_message (m.string)
			end
		end

	append_message_file_content (fn: STRING)
			-- Append file content from `fn' to the response
			--| To use with care.
			--| You should avoid using this for big or binary content ...
		local
			f: RAW_FILE
		do
			create f.make (fn)
			if f.exists and then f.is_readable then
				f.open_read
				from
				until
					f.exhausted
				loop
					f.read_stream (1024)
					append_message (f.last_string)
				end
				f.close
			end
		end

feature -- Output

	update_content_length (a_overwrite: BOOLEAN)
			-- Update content length
			-- if the header already exists it won't change it,
			-- unless `a_overwrite' is set to True
		local
			hds: like headers
			len: INTEGER
		do
			hds := headers
			if a_overwrite or else not hds.has_content_length then
				if attached message as m then
					len := m.count
--					if {PLATFORM}.is_windows then
--						len := len + m.occurrences ('%N') --| FIXME: find better solution
--					end
				else
					len := 0
				end
				hds.put_content_length (len)
			end
		end

	compute
			-- Compute the string output
		do
			update_content_length (False)
			internal_headers_string := headers.string
		end

	headers_string: STRING
		local
			o: like internal_headers_string
		do
			o := internal_headers_string
			if o = Void then
				compute
				o := internal_headers_string
				if o = Void then
					check output_computed: False end
					create o.make_empty
				end
			end
			Result := o
		end

	send (res: WSF_RESPONSE)
		do
			compute
			res.set_status_code (200)
			res.put_header_text (headers_string)
			if attached message as m then
				res.put_string (m)
			end
		end

feature {NONE} -- Implementation: output

	internal_headers_string: detachable like headers_string

;note
	copyright: "Copyright (c) 1984-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
