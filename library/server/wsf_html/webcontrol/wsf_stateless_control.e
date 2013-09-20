note
	description: "Summary description for {WSF_STATELESS_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_STATELESS_CONTROL

feature {NONE}

	make (a_tag_name: STRING)
		do
			tag_name := a_tag_name
			create css_classes.make (0)
		ensure
			attached css_classes
		end

feature -- Access

	tag_name: STRING

	css_classes: ARRAYED_LIST [STRING]

		--TODO: Maybe improve

feature -- Change

	add_class (c: STRING)
		do
			css_classes.force (c)
		end

	render_tag (body, attrs: STRING): STRING
		local
			css_classes_string: STRING
		do
			create css_classes_string.make_empty
			across
				css_classes as c
			loop
				css_classes_string.append (" " + c.item)
			end
			Result := render_tag_with_tagname (tag_name, body, attrs, css_classes_string)
		end

	render_tag_with_tagname (tag, body, attrs, css_classes_string: STRING): STRING
		local
			l_attributes: STRING
		do
			create l_attributes.make_from_string (attrs)
			if not css_classes_string.is_empty then
				l_attributes.append (" class=%"")
				l_attributes.append (css_classes_string)
				l_attributes.append_character ('%"')
			end
			Result := "<" + tag + " " + l_attributes
			if
				body.is_empty and
				not tag.same_string ("textarea") and
				not tag.same_string ("span") and
				not tag.same_string ("button") and
				not tag.same_string ("ul")
			then
				Result.append (" />")
			else
				Result.append (" >" + body + "</" + tag + ">")
			end
		end

	render: STRING
			-- Return html representation of control
		deferred
		end

end
