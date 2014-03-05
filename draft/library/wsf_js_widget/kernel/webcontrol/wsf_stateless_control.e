note
	description: "[
		This class is the base class of the framework.
		Stateless controls are HTML elements which have no state (e.g.
		headers, layout containers or static text fields. Stateful
		controls (WSF_CONTROL) are subtypes	of this class.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_STATELESS_CONTROL

feature {NONE} -- Initialization

	make (a_tag_name: STRING_32)
			-- Initialize with specified tag
		require
			not a_tag_name.is_empty
		do
			tag_name := a_tag_name
			create css_classes.make (0)
		end

feature -- Access

	tag_name: STRING_32
			-- The tag name

	css_classes: ARRAYED_LIST [STRING_32]
			-- List of classes (appear in the "class" attribute)

	attributes: detachable STRING_32
			-- Attributes string (without classes)

feature -- Change

	add_class (c: STRING_32)
			-- Add a css class to this control
		do
			css_classes.force (c)
		end

	remove_class (cla: STRING_32)
			-- Add a css class to this control
		do
			css_classes.prune (cla)
		end

	append_attribute (a: STRING_32)
			-- Adds the specified attribute to the attribute string of this control
		do
			if attached attributes as attr then
				attr.append (" ")
				attr.append (a)
			else
				attributes := a
			end
		end

feature -- Rendering

	render_tag (body: STRING_32; attrs: detachable STRING_32): STRING_32
			-- Generate HTML of this control with the specified body and attributes
		local
			css_classes_string: STRING_32
		do
			create css_classes_string.make_empty
			across
				css_classes as c
			loop
				css_classes_string.append (" " + c.item)
			end
			Result := render_tag_with_tagname (tag_name, body, attrs, css_classes_string)
		end

	render_tag_with_tagname (tag, body: STRING_32; attrs: detachable STRING_32; css_classes_string: STRING_32): STRING_32
			-- Generate HTML of the specified tag with specified body, attributes and css classes
		local
			l_attributes: STRING_32
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
				-- Check if we have to render a body. For some elements, this is not the case (like textareas) or only if the body is not empty.
			if body.is_empty and not tag.same_string ("textarea") and not tag.same_string ("span") and not tag.same_string ("button") and not tag.same_string ("ul") and not tag.same_string ("div") then
				Result.append (" />")
			else
				Result.append (" >" + body + "</" + tag + ">")
			end
		end

	render_tag_with_body (body: STRING_32): STRING_32
			-- Generate HTML of this control with the specified body
		do
			Result := render_tag (body, attributes)
		end

	render: STRING_32
			-- Return html representation of control
		deferred
		end

end
