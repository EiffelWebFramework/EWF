note
	description: "[
		Mutli controls are used as containers for multiple controls, for
		example a form is a multi control.
	]"
	author: ""
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

feature

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
		do
			across
				controls as e
			loop
				if attached {WSF_CONTROL} e.item as el then
					el.control_name_prefix := control_name_prefix + control_id.out + "_"
				end
			end
		end

feature

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

feature -- Event handling

	handle_callback (cname: LIST [STRING_32]; event: STRING_32; event_parameter: detachable ANY)
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

end
