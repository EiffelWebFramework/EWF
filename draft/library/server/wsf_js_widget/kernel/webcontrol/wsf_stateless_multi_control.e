note
	description: "[
		Mutli controls are used as containers for multiple controls, for
		example a form is a multi control.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_STATELESS_MULTI_CONTROL [G -> WSF_STATELESS_CONTROL]

inherit
	WSF_MULTI_CONTROL [G]
		rename
			make as make_multi_control
		redefine
			add_control,
			set_control_name_prefix,
			handle_callback,
			set_control_id,
			render_tag
		end

create
	make_with_tag_name, make

feature {NONE} -- Initialization

	make
			-- Initialize
		do
			make_with_tag_name ("")
		end

feature -- Change

	set_control_id (d: INTEGER)
			-- Set id of this control and update subcontrol prefixes
		do
			control_id := d
			set_subcontrol_prefixes
		ensure then
			control_id_set: control_id.abs = d
		end

	set_control_name_prefix (p: STRING_32)
			-- Set control name prefix of this control
		do
			control_name_prefix := p
			set_subcontrol_prefixes
		ensure then
			control_name_prefix_set: control_name_prefix.same_string (p)
		end

	set_subcontrol_prefixes
			-- Update subcontrol prefixes
		local
			s: STRING_32
		do
			across
				controls as ic
			loop
				if attached {WSF_CONTROL} ic.item as l_control then
					create s.make_from_string (control_name_prefix)
					s.append_integer (control_id)
					s.append_character ('_')
					l_control.set_control_name_prefix (s)
				end
			end
		end

feature -- Change

	add_control (c: G)
			-- Add a control to this multi control
		do
			controls.extend (c)
			if attached {WSF_CONTROL} c as d then
				d.control_id := controls.count
				d.control_name_prefix := control_name_prefix + control_id.out + "_"
			end
		ensure then
			control_added: controls.has (c)
		end

	render_tag (body: READABLE_STRING_32; attrs: detachable READABLE_STRING_32): STRING_32
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

feature -- Event handling

	handle_callback (cname: LIST [READABLE_STRING_GENERAL]; event: READABLE_STRING_GENERAL; event_parameter: detachable ANY)
			-- Pass callback to subcontrols
		do
			across
				controls as c
			until
				cname.is_empty
			loop
				if attached {WSF_CONTROL} c.item as cont then
					cont.handle_callback (cname, event, event_parameter)
				end
			end
		end

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
