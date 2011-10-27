note
	description: "Summary description for {HTML_PAGE}."
	date: "$Date$"
	revision: "$Revision$"

class
	HTML_PAGE

inherit
	HTML_UTILITIES

create
	make

feature {NONE} -- Initialization

	make (a_title: like title)
		do
			create {ARRAYED_LIST [like html_attributes.item]} html_attributes.make (0)
			create head.make (a_title)
			create {ARRAYED_LIST [like body_attributes.item]} body_attributes.make (0)
			create body.make_empty
			initialize
		end

	initialize
			-- Initialize
		do
			create headers.make
		end

feature -- Access

	headers: WSF_HEADER

feature -- Recycle

	recycle
		do
			html_attributes.wipe_out
			headers.recycle
			head.recycle
			body_attributes.wipe_out
			body.wipe_out
			internal_header_string := Void
			internal_message_string := Void
		end

feature -- Access

	html_attributes: LIST [TUPLE [name: STRING; value: STRING]]

	head: HTML_PAGE_HEAD

	body_attributes: LIST [TUPLE [name: STRING; value: STRING]]

	body: STRING

feature -- Query

	title: detachable STRING
		do
			Result := head.title
		end

	add_html_ttribute (a: like html_attributes.item)
		do
			html_attributes.force (a)
		end

	add_body_attribute (a: like body_attributes.item)
		do
			body_attributes.force (a)
		end

	set_body (s: like body)
			-- Set `body' to `s'
		do
			body := s
		end

feature -- Element change

	set_title (t: like title)
		do
			head.title := t
		end

feature -- Output

	compute
			-- Compute the string output
		local
			s, t: STRING
		do
				--| HTML beginning
			create s.make (128)
			s.append_string ("<html")
			s.append_string (attributes_to_string (html_attributes))
			s.append_string (">%N")

				--| Head
			head.compute --| Be sure to have a fresh string
			t := head.string
			if not t.is_empty then
				s.append_string (t)
				s.append_character ('%N')
			end

				--| Body
			s.append_string ("<body")
			s.append_string (attributes_to_string (body_attributes))
			s.append_string (">%N")
			s.append_string (body)
			s.append_string ("</body>")

				--| End
			s.append_string ("</html>")

				--| Http headers
			headers.put_content_length (s.count)
			internal_header_string := headers.string
			internal_message_string := s
		end

	header_string: STRING
		local
			o: like internal_header_string
		do
			o := internal_header_string
			if o = Void then
				compute
				o := internal_header_string
				if o = Void then
					check output_computed: False end
					create o.make_empty
				end
			end
			Result := o
		end

	message_string: STRING
		local
			o: like internal_message_string
		do
			o := internal_message_string
			if o = Void then
				compute
				o := internal_message_string
				if o = Void then
					check output_computed: False end
					create o.make_empty
				end
			end
			Result := o
		end

	send (buf: WSF_RESPONSE)
		do
			buf.set_status_code (200)
			buf.write_headers_string (header_string)
			buf.write_string (message_string)
		end

feature {NONE} -- Implementation: output

	internal_header_string: detachable like header_string

	internal_message_string: detachable like message_string

invariant
	header_attached: headers /= Void

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
