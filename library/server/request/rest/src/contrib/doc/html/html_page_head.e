note
	description: "Summary description for {HTML_PAGE_HEAD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HTML_PAGE_HEAD

inherit
	HTML_UTILITIES

create
	make

feature {NONE} -- Initialization

	make (a_title: like title)
		do
			initialize
			title := a_title
		end

	initialize
		do
			create text.make_empty
			create {ARRAYED_LIST [like attributes.item]} attributes.make (0)
		end

feature -- Recycle

	recycle
		do
			attributes.wipe_out
			title := Void
			text.wipe_out
			internal_string := Void
		end

feature -- Access

	attributes: LIST [TUPLE [name: STRING; value: STRING]]

	title: detachable STRING assign set_title

	text: STRING

feature -- Element change

	set_title (t: like title)
		do
			title := t
		end

feature -- Output

	compute
			-- Compute the string output
		local
			s: STRING
		do
			create s.make_empty
			if attached title as t then
				s.append_string ("<title>" + t + "</title>%N")
			end
			if text.count > 0 then
				s.append_string (text)
				s.append_character ('%N')
			end
			if s.count > 0 then
				internal_string := "<head" + attributes_to_string (attributes) + ">%N" + s + "</head>"
			else
				internal_string := s
			end
		end

	string: STRING
			--
		local
			o: like internal_string
		do
			o := internal_string
			if o = Void then
				compute
				o := internal_string
				if o = Void then
					check output_computed: False end
					create o.make_empty
				end
			end
			Result := o
		end

feature {NONE} -- Implementation: output

	internal_string: detachable like string

invariant
	text_attached: text /= Void

note
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
