note
	description: "Summary description for {WSF_STATELESS_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_STATELESS_CONTROL

feature

	tag_name: STRING

	css_classes: LINKED_LIST [STRING]

		--TODO: Maybe improve

feature {NONE}

	make (a_tag_name: STRING)
		do
			tag_name := a_tag_name
			create css_classes.make
		ensure
			attached css_classes
		end

feature

	add_class (c: STRING)
		do
			css_classes.extend (c)
		end

	render_tag (body, attrs: STRING): STRING
		local
			css_classes_string: STRING
		do
			css_classes_string := ""
			across
				css_classes as c
			loop
				css_classes_string := css_classes_string + " " + c.item
			end
			Result := render_tag_with_tagname (tag_name, body, attrs, css_classes_string)
		end

	render_tag_with_tagname (tag, body, attrs, css_classes_string: STRING): STRING
		local
			l_attributes: STRING
		do
			l_attributes := attrs
			if not css_classes_string.is_empty then
				l_attributes := l_attributes + " class=%"" + css_classes_string + "%""
			end
			Result := "<" + tag + " " + l_attributes
			if body.is_empty and not tag.is_equal ("textarea") and not tag.is_equal ("span") and not tag.is_equal ("button") and not tag.is_equal ("ul") then
				Result := Result + " />"
			else
				Result := Result + " >" + body + "</" + tag + ">"
			end
		end

	render: STRING
			-- Return html representaion of control
		deferred
		end

end
