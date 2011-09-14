note
	description: "Summary description for {REST_API_DOCUMENTATION_HTML_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REST_API_DOCUMENTATION_HTML_PAGE

inherit
	HTML_PAGE
		redefine
			head,
			initialize,
			recycle,
			compute
		end

create
	make

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			create {LINKED_LIST [like shortcuts.item]} shortcuts.make
		end

feature -- Recyle

	recycle
		do
			Precursor
			shortcuts.wipe_out
		end

feature -- Access

	head: REST_API_DOCUMENTATION_HTML_PAGE_HEAD

	big_title: detachable STRING

	shortcuts: LIST [TUPLE [name: STRING; anchor: STRING]]

	add_shortcut (s: STRING)
		local
			t: STRING
		do
			t := s.string
			t.replace_substring_all ("/", "-")
			shortcuts.force ([s,t])
		end

	last_added_shortcut: STRING
		do
			if shortcuts.count > 0 and then attached shortcuts.last as sht then
				Result := sht.anchor
			else
				create Result.make_empty
			end
		end

	shortcuts_to_html: detachable STRING
		do
			if not shortcuts.is_empty then
				from
					create Result.make_from_string ("<strong>Shortcuts:</strong> | ")
					shortcuts.start
				until
					shortcuts.after
				loop
					Result.append_string ("<a href=%"#"+ shortcuts.item.anchor +"%">"+ shortcuts.item.name +"</a> | ")
					shortcuts.forth
				end
			end
		end

feature -- Element change

	set_big_title (t: like big_title)
		do
			big_title := t
		end

feature -- Basic operation

	compute
		local
			l_old_body: STRING
			sh, bt: detachable STRING
		do
			sh := shortcuts_to_html
			bt := big_title
			if sh /= Void or bt /= Void then
				l_old_body := body
				if bt /= Void then
					bt := "<h1>" + bt + "</h2>%N"
					if sh /= Void then
						body := bt + sh + l_old_body
					else
						body := bt + l_old_body
					end
				elseif sh /= Void then
					body := sh + l_old_body
				end
				Precursor
				body := l_old_body
			else
				Precursor
			end
		end

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
