note
	description: "Summary description for {WSF_REPEATER_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_REPEATER_CONTROL [G -> WSF_ENTITY]

inherit

	WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		rename
			make as make_multi_control
		redefine
			set_state,
			state,
			render
		end

feature {NONE} -- Initialization

	make (a_datasource: WSF_DATASOURCE [G])
		local
			p: WSF_PAGINATION_CONTROL [G]
		do
			make_multi_control
			datasource := a_datasource
			datasource.set_on_update_agent (agent update)
			if attached {WSF_PAGABLE_DATASOURCE [G]} a_datasource as ds then
				create p.make (ds)
				add_control (p)
				pagination_control := p
			end
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	update
			-- Send new rendered control to client on update
		do
			state_changes.replace (create {JSON_STRING}.make_from_string_32 (render_body), "_body")
			state_changes.replace (datasource.state, "datasource")
		end

	set_state (new_state: JSON_OBJECT)
			-- Restore datasource state from json
		do
			if attached {JSON_OBJECT} new_state.item ("datasource") as datasource_state then
				datasource.set_state (datasource_state)
			end
		end

	state: WSF_JSON_OBJECT
			-- Return state which contains the current datasource state
		do
			create Result.make
			Result.put (datasource.state, "datasource")
		end

feature -- Rendering

	render_item (item: G): STRING_32
			-- Render item
		deferred
		end

	render_body: STRING_32
			-- Render Body
		do
			create Result.make_empty
			across
				datasource.data as ic
			loop
				Result.append (render_item (ic.item))
			end
		end

	render: STRING_32
			-- Render repeater inclusive paging if paging is available
		local
			content: STRING_32
		do
			content := render_tag_with_tagname ("div", render_body, "", "repeater_content")
			create Result.make_empty
			across
				controls as ic
			loop
					-- CHECK: Prepend ? or Append?
				Result.prepend (ic.item.render)
			end
				-- Fix generator name since the user will extend this class to define item_render
			Result := render_tag_with_generator_name ("WSF_REPEATER_CONTROL", content + Result, "")
		end

feature -- Access

	datasource: WSF_DATASOURCE [G]

	pagination_control: detachable WSF_PAGINATION_CONTROL [G]

;note
	copyright: "2011-2015, Yassin Hassan, Severin Munger, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
