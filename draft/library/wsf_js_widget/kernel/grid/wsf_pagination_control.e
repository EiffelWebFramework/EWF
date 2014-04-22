note
	description: "Summary description for {WSF_PAGINATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_PAGINATION_CONTROL [G -> WSF_ENTITY]

inherit

	WSF_CONTROL
		rename
			make as make_control
		end

create
	make

feature {NONE}

	make (ds: WSF_PAGABLE_DATASOURCE [G])
		do
			make_control ( "ul")
			add_class ("pagination")
			datasource := ds
			datasource.set_on_update_page_agent (agent update)
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	state: WSF_JSON_OBJECT
			-- Return empty
		do
			create Result.make
		end

	set_state (new_state: JSON_OBJECT)
			-- There is no state to restore states
		do
		end

	update
			-- Send new renederd control to client on update
		do
			state_changes.replace (create {JSON_STRING}.make_json_from_string_32 (render), "_html")
		end

feature --Event handling

	handle_callback (cname: LIST [READABLE_STRING_GENERAL]; event: READABLE_STRING_GENERAL; event_parameter: detachable ANY)
			-- Handle goto/next/prev events
		do
			if control_name.same_string_general (cname.first) then
				if event.same_string ("next") then
					datasource.set_page (datasource.page + 1)
				elseif event.same_string ("prev") then
					datasource.set_page (datasource.page - 1)
				elseif event.same_string ("goto") then
					if
						attached {READABLE_STRING_GENERAL} event_parameter as p and then
						attached p.to_integer as i
					then
						datasource.set_page (i)
					end
				end
				datasource.update
			end
		end

feature -- Render

	render: STRING_32
			-- Render paging control
		local
			paging_start: INTEGER
			paging_end: INTEGER
			cssclass: STRING_32
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
				Result.append (render_tag_with_tagname ("li", render_tag_with_tagname ("a", n.item.out, "href=%"#%" data-nr=%"" + n.item.out + "%"", ""), "", cssclass))
			end
			Result.append (render_tag_with_tagname ("li", render_tag_with_tagname ("a", "&raquo;", "href=%"#%" data-nr=%"next%"", ""), "", ""))
			Result := render_tag (Result, "")
		end

feature -- Properties

	datasource: WSF_PAGABLE_DATASOURCE [G]

;note
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
