note
	description: "Summary description for {WSF_STATELESS_HTML_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_STATELESS_HTML_CONTROL

inherit

	WSF_STATELESS_CONTROL

create
	make_html

feature {NONE}

	make_html (t, v: STRING)
		do
			make ( t)
			html := v
		end


feature -- Implementation

	render: STRING
		do
			Result := render_tag (html, "")
		end



feature

	html: STRING

end

