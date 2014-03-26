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
			a_tag_name_not_empty: not a_tag_name.is_empty
		do
			tag_name := a_tag_name
			create css_classes.make (0)
		ensure
			tag_name_set: tag_name = a_tag_name
		end

feature -- Change

	add_class (a_css_class: STRING_32)
			-- Add a css class to this control
		require
			a_css_class_not_empty: not a_css_class.is_empty
		do
			css_classes.force (a_css_class)
		ensure
			class_added: css_classes.has (a_css_class)
		end

	remove_class (a_css_class: STRING_32)
			-- Remove a css class from this control
		require
			c_not_empty: not a_css_class.is_empty
		do
			css_classes.start
			css_classes.prune_all (a_css_class)
		ensure
			c_removed: not css_classes.has (a_css_class)
		end

	append_attribute (att: READABLE_STRING_32)
			-- Adds the specified attribute to the attribute string of this control
		require
			att_not_empty: not att.is_empty
		do
			if attached attributes as attr then
				attr.append_character (' ')
				attr.append (att)
			else
				create attributes.make_from_string (att)
			end
		end

feature -- Rendering

	render_tag (a_body: READABLE_STRING_32; attrs: detachable READABLE_STRING_32): STRING_32
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
			Result := render_tag_with_tagname (tag_name, a_body, attrs, css_classes_string)
		end

	render_tag_with_tagname (tag, a_body: READABLE_STRING_32; attrs: detachable READABLE_STRING_32; css_classes_string: READABLE_STRING_32): STRING_32
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
			create Result.make_empty
			Result.append_character ('<')
			Result.append (tag)
			Result.append_character (' ')
			Result.append (l_attributes)
				-- Check if we have to render a body. For some elements, this is not the case (like textareas) or only if the body is not empty.
			if
				a_body.is_empty and
			 	not tag.same_string ("textarea") and
			 	not tag.same_string ("span") and
			 	not tag.same_string ("button") and
			 	not tag.same_string ("ul") and
			 	not tag.same_string ("div")
			 then
			 		-- Note: it should be ok to close for textarea, span, ... and so on.

				Result.append ("/>")
			else
				Result.append (" >")
				Result.append (a_body)
				Result.append ("</")
				Result.append (tag)
				Result.append (">")
			end
		end

	render_tag_with_body (body: READABLE_STRING_32): STRING_32
			-- Generate HTML of this control with the specified body
		do
			Result := render_tag (body, attributes)
		end

	render: STRING_32
			-- Return html representation of control
		deferred
		end

feature -- Properties

	tag_name: STRING_32
			-- The tag name

	css_classes: ARRAYED_LIST [STRING_32]
			-- List of classes (appear in the "class" attribute)

	attributes: detachable STRING_32
			-- Attributes string (without classes)

invariant
	tag_name_not_empty: not tag_name.is_empty

note
	copyright: "2011-2014, Yassin Hassan, Severin Munger, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
