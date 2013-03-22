note
	description: "Summary description for {WSF_DEFAULT_ROUTER_RESPONSE}."
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_DEFAULT_ROUTER_RESPONSE

inherit
	WSF_DEFAULT_RESPONSE
		redefine
			send_to,
			not_found_message
		end

create
	make_with_router

feature {NONE} -- Initialization

	make_with_router (req: WSF_REQUEST; a_router: like router)
			-- Initialize Current with request `req' and router `a_router'
			-- Initialize Current with request `req'
		do
			router := a_router
			make (req)
		end

feature -- Access

	router: WSF_ROUTER
			-- Associated router.

feature -- Settings

	documentation_included: BOOLEAN
			-- Include self-documentation from `router' in the response?

feature -- Change

	set_documentation_included (b: BOOLEAN)
		do
			documentation_included := b
		end

feature {WSF_RESPONSE} -- Output

	send_to (res: WSF_RESPONSE)
			-- Send Current message to `res'
			--
			-- This feature should be called via `{WSF_RESPONSE}.send (obj)'
			-- where `obj' is the current object
		local
			msg: WSF_RESPONSE_MESSAGE
			req: like request
		do
			req := request
			if req.is_request_method ({HTTP_REQUEST_METHODS}.method_trace) then
				msg := trace_message (req)
			elseif attached method_not_allowed_message (req) as not_allowed then
				msg := not_allowed
			else
				msg := not_found_message (req)
			end
			res.send (msg)
		end

feature {NONE} -- Implementation

	method_not_allowed_message (req: WSF_REQUEST): detachable WSF_METHOD_NOT_ALLOWED_RESPONSE
		local
			vis: WSF_ROUTER_AGENT_ITERATOR
		do
			if attached router.allowed_methods_for_request (req) as l_allowed_mtds and then not l_allowed_mtds.is_empty then
				create Result.make (req)
				Result.set_suggested_methods (l_allowed_mtds)

				if documentation_included then
					create vis
					vis.on_item_actions.extend (agent (i: WSF_ROUTER_ITEM; r: WSF_METHOD_NOT_ALLOWED_RESPONSE)
							local
								l_is_hidden: BOOLEAN
								s: STRING_32
							do
								-- Keep only mapping for the request's method
								if
									not attached i.request_methods as l_methods or else
									l_methods.has (request.request_method)
								then
									if attached {WSF_SELF_DOCUMENTED_ROUTER_MAPPING} i.mapping as l_doc_mapping then
										l_is_hidden := l_doc_mapping.documentation (i.request_methods).is_hidden
									end
									if not l_is_hidden then
										create s.make_from_string (i.mapping.associated_resource)
										if attached i.request_methods as mtds then
											s.append (" [ ")
											across
												mtds as mtds_c
											loop
												s.append (mtds_c.item)
												s.append_character (' ')
											end
											s.append ("]")
										else
											s.append (" [*]")
										end
										r.add_suggested_text (s, Void)
									end
								end
							end (?, Result))
					vis.process_router (router)
				end
			end
		end

	not_found_message (req: WSF_REQUEST): WSF_NOT_FOUND_RESPONSE
		local
			vis: WSF_ROUTER_AGENT_ITERATOR
		do
			Result := Precursor (req)
			if documentation_included then
				create vis
				vis.on_item_actions.extend (agent (i: WSF_ROUTER_ITEM; r: WSF_NOT_FOUND_RESPONSE; m: detachable READABLE_STRING_8)
						local
							l_is_hidden: BOOLEAN
							s: STRING_32
							ok: BOOLEAN
						do
							if attached {WSF_SELF_DOCUMENTED_ROUTER_MAPPING} i.mapping as l_doc_mapping then
								l_is_hidden := l_doc_mapping.documentation (i.request_methods).is_hidden
							end
							if not l_is_hidden then
								ok := True
								create s.make_from_string (i.mapping.associated_resource)
								if attached i.request_methods as mtds then
									ok := False
									s.append (" [ ")
									across
										mtds as c
									loop
										if m = Void or else m.is_case_insensitive_equal (c.item) then
											ok := True
										end
										s.append (c.item)
										s.append_character (' ')
									end
									s.append ("]")
								else
									s.append (" [*]")
								end
								if ok then
									r.add_suggested_text (s, Void)
								end
							end
						end (?, Result, req.request_method))
				vis.process_router (router)
			end
		end

note
	copyright: "2011-2013, Jocelyn Fiat, Javier Velilla, Olivier Ligot, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
