note
	description: "Summary description for {WSF_SELF_DOCUMENTED_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_SELF_DOCUMENTED_HANDLER

feature -- Documentation

	mapping_documentation (m: WSF_ROUTER_MAPPING; a_request_methods: detachable WSF_REQUEST_METHODS): WSF_ROUTER_MAPPING_DOCUMENTATION
			-- Documentation associated with Current handler, in the context of the mapping `m' and methods `a_request_methods'.
			--| `m' and `a_request_methods' are useful to produce specific documentation when the handler is used for multiple mapping.
		deferred
		end

end
