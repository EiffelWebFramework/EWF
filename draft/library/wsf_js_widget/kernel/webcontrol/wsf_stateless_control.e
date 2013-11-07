note
	description: "Summary description for {WSF_STATELESS_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_STATELESS_CONTROL

feature {NONE} -- Initialization

	make (a_tag_name: STRING)
			-- Initialize with specified tag
		require
			not a_tag_name.is_empty
		do
			tag_name := a_tag_name
			create css_classes.make (0)
		end

feature -- Access

	tag_name: STRING
			-- The tag name

	css_classes: ARRAYED_LIST [STRING]
			-- List of classes (appear in the "class" attribute)

	attributes: detachable STRING
			-- Attributes string (without classes)

feature -- Change

	add_class (c: STRING)
			-- Add a css class to this control
		do
			css_classes.force (c)
		end

	remove_class (cla: STRING)
			-- Add a css class to this control
		do
			css_classes.prune (cla)
		end

feature -- Rendering

	render_tag (body: STRING; attrs: detachable STRING): STRING
			-- Generate HTML of this control with the specified body and attributes
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

	render_tag_with_tagname (tag, body: STRING; attrs: detachable STRING; css_classes_string: STRING): STRING
			-- Generate HTML of the specified tag with specified body, attributes and css classes
		local
			l_attributes: STRING
		do
			if attached attrs as a then
				create l_attributes.make_from_string (a)
			else
				l_attributes := ""
			end
			if not css_classes_string.is_empty then
				l_attributes.append (" class=%"")
				l_attributes.append (css_classes_string)
				l_attributes.append_character ('%"')
			end
			Result := "<" + tag + " " + l_attributes
			if body.is_empty and not tag.same_string ("textarea") and not tag.same_string ("span") and not tag.same_string ("button") and not tag.same_string ("ul") then
				Result.append (" />")
			else
				Result.append (" >" + body + "</" + tag + ">")
			end
		end

	render_tag_with_body (body: STRING): STRING
			-- Generate HTML of this control with the specified body
		do
			if attached attributes as attrs then
				Result := render_tag (body, attrs)
			else
				Result := render_tag (body, "")
			end
		end

	render: STRING
			-- Return html representation of control
		deferred
		end

end
