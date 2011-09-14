note
	description: "Summary description for {REST_API_DOCUMENTATION_HTML_PAGE_HEAD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REST_API_DOCUMENTATION_HTML_PAGE_HEAD

inherit
	HTML_PAGE_HEAD
		redefine
			initialize,
			compute
		end

create
	make

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			style := "[
				body {margin: 0px;}
				a { text-decoration: none; }
				h1 { padding: 10px; border: solid 2px #000; background-color: #009; color: #fff;}
				div.api { padding: 5px; margin-bottom: 10px;} 
				div.api .api-description { padding: 5px 5px 5px 0px; font-style: italic; color: #090;} 
				div.api div.inner { padding-left: 40px;} 
				div.api h2>a { color: #009; text-decoration: none;} 
				div.api a.api-format { color: #009; text-decoration: none;} 
				div.api a.api-format.selected { padding: 0 4px 0 4px; color: #009; text-decoration: none; border: solid 1px #99c; background-color: #eeeeff;} 
				div.api>h2 { margin: 2px; padding: 2px 2px 2px 10px; display: inline-block; border: dotted 1px #cce; width: 100%; color: #009; background-color: #E7F3F8; text-decoration: none; font-weight: bold; font-size: 120%;} 
				div.api span.note { font-style: italic;}
			]"
		end

feature {REST_API_DOCUMENTATION_HTML_PAGE} -- Access

	style: STRING

feature -- Output

	compute
			-- Compute the string output
		local
			s: detachable STRING
			p: INTEGER
		do
			Precursor
			s := internal_string
			if s /= Void then
				p := s.substring_index ("</head>", 1)
				if p > 0 then
					s.insert_string ("<style>%N" + style + "%N</style>%N", p)
				else
					s.append_string ("<style>%N" + style + "%N</style>%N")
				end
			end
		end


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
