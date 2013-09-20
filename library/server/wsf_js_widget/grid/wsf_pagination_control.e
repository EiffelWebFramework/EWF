note
	description: "Summary description for {WSF_PAGINATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_PAGINATION_CONTROL [G -> WSF_ENTITY]

inherit

	WSF_CONTROL

create
	make_paging

feature {NONE}

	make_paging (n: STRING; ds: WSF_PAGABLE_DATASOURCE [G])
		do
			make_control (n, "ul")
			add_class ("pagination")
			datasource := ds
			datasource.set_on_update_page_agent (agent update)
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- STATE MANAGEMENT

	state: JSON_OBJECT
			-- Return state which contains the current html and if there is an event handle attached
		do
			create Result.make
		end

	set_state (new_state: JSON_OBJECT)
		do
		end

feature --EVENT HANDLING

	handle_callback (cname: STRING; event: STRING; event_parameter: detachable STRING)
		do
			if Current.control_name.same_string (cname) then
				if event.same_string ("next") then
					datasource.set_page (datasource.page + 1)
				elseif event.same_string ("prev") then
					datasource.set_page (datasource.page - 1)
				elseif event.same_string ("goto") then
					if attached event_parameter as p and then attached p.to_integer as i then
						datasource.set_page (i)
					end
				end
				datasource.update
			end
		end

feature

	update
		do
			state_changes.replace (create {JSON_STRING}.make_json (render), "_html")
		end

	render: STRING
		local
			paging_start: INTEGER
			paging_end: INTEGER
			cssclass: STRING
		do
			Result := render_tag_with_tagname ("li", render_tag_with_tagname ("a", "&laquo;", "href=%"#%" data-nr=%"prev%"", ""), "", "")
			paging_start := (datasource.page - 4).max (1)
			paging_end := (paging_start + 8).min (datasource.page_count)
			paging_start := (paging_end - 8).max (1)
			across
				paging_start |..| paging_end as n
			loop
				if n.item = datasource.page then
					cssclass := "active"
				else
					cssclass := ""
				end
				Result := Result + render_tag_with_tagname ("li", render_tag_with_tagname ("a", n.item.out, "href=%"#%" data-nr=%"" + n.item.out + "%"", ""), "", cssclass)
			end
			Result := Result + render_tag_with_tagname ("li", render_tag_with_tagname ("a", "&raquo;", "href=%"#%" data-nr=%"next%"", ""), "", "")
			Result := render_tag (Result, "")
		end

feature

	datasource: WSF_PAGABLE_DATASOURCE [G]

end
