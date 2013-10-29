note
	description: "Summary description for {WSF_REPEATER_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_REPEATER_CONTROL [G -> WSF_ENTITY]

inherit

	WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		redefine
			set_state,
			state,
			render
		end

feature {NONE} -- Initialization

	make_repeater (n: STRING; a_datasource: WSF_DATASOURCE [G])
		local
			p: WSF_PAGINATION_CONTROL [G]
		do
			make_multi_control (n)
			datasource := a_datasource
			datasource.set_on_update_agent (agent update)
			if attached {WSF_PAGABLE_DATASOURCE [G]} a_datasource as ds then
				create p.make_paging (n + "_paging", ds)
				add_control (p)
				pagination_control := p
			end
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	update
			-- Send new renederd control to client on update
		do
			state_changes.replace (create {JSON_STRING}.make_json (render_body), "_body")
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

	render_item (item: G): STRING
			--Render item
		deferred
		end

	render_body: STRING
			--Render Body
		do
			Result := ""
			across
				datasource.data as entity
			loop
				Result.append (render_item (entity.item))
			end
		end

	render: STRING
			--Render repeater inclusive paging if paging is available
		local
			content: STRING
		do
			content := render_tag_with_tagname ("div", render_body, "", "repeater_content")
			Result := ""
			across
				controls as c
			loop
				Result := c.item.render + Result
			end
				-- Fix generator name since the user will extend this class to define item_render
			Result := render_tag_with_generator_name ("WSF_REPEATER_CONTROL", content + Result, "")
		end

feature -- Properties

	datasource: WSF_DATASOURCE [G]

	pagination_control: detachable WSF_PAGINATION_CONTROL [G]

end
