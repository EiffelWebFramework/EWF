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
			handle_callback,
			render
		end

feature {NONE}

	make_repeater (n: STRING; a_datasource: WSF_DATASOURCE [G])
		do
			make_multi_control (n)
			datasource := a_datasource
			datasource.set_on_update_agent (agent update)
			if attached {WSF_PAGABLE_DATASOURCE [G]} a_datasource as ds then
				create pagination_control.make_paging (n + "_paging", ds)
				add_control (pagination_control)
			end
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- STATE MANAGEMENT

	update
		do
			state_changes.replace (create {JSON_STRING}.make_json (render_body), "_body")
			state_changes.replace (datasource.state, "datasource")
		end

	set_state (new_state: JSON_OBJECT)
			-- Restore html from json
		do
			if attached {JSON_OBJECT} new_state.item ("datasource") as datasource_state then
				datasource.set_state (datasource_state)
			end
		end

	state: JSON_OBJECT
			-- Return state which contains the current html and if there is an event handle attached
		do
			create Result.make
			Result.put (datasource.state, "datasource")
		end

feature --EVENT HANDLING

	handle_callback (cname: STRING; event: STRING; event_parameter: detachable STRING)
		do
			Precursor (cname, event, event_parameter)
		end

feature -- Implementation

	render_item (item: G): STRING
		deferred
		end

	render_body: STRING
		do
			Result := ""
			across
				datasource.data as entity
			loop
				Result.append (render_item (entity.item))
			end
		end

	render: STRING
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

feature

	datasource: WSF_DATASOURCE [G]

	pagination_control: detachable WSF_PAGINATION_CONTROL [G]

end
