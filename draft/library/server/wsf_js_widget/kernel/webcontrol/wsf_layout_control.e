note
	description: "[
		A lightweight layout container to encapsulate the grid layout
		provided by bootstrap.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_LAYOUT_CONTROL

inherit

	WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		rename
			make as make_stateless_multi_control,
			add_control as add_control_raw
		end

create
	make

feature {NONE} -- Initialization

	make
			--Initialize
		do
			make_with_tag_name ("div")
			add_class ("row")
		end

feature -- Add control

	add_control_with_offset (c: WSF_STATELESS_CONTROL; span, offset: INTEGER)
			-- Add a control as column with the specified span and offset
		require
			offset_in_range: offset >= 0 and offset <= 12
			span_in_range: span >= 0 and span <= 12 - offset
		local
			div: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		do
			create div.make_with_tag_name ("div")
			div.add_class ("col-md-" + span.out + " col-md-offset-" + offset.out)
			div.add_control (c)
			add_control_raw (div)
		end

	add_control (col: INTEGER; c: WSF_STATELESS_CONTROL)
			-- Add a control to the specified column
		require
			col >= 1 and col <= controls.count
			attached {WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]} controls [col]
		do
			if attached {WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]} controls [col] as div then
				div.add_control (c)
			end
		end

	add_column (span: INTEGER)
			-- Add a multi control as Bootstrap column with the specified span
		require
			span_in_range: span >= 0 and span <= 12
		local
			div: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		do
			create div.make_with_tag_name ("div")
			div.add_class ("col-md-" + span.out)
			add_control_raw (div)
		end

end
