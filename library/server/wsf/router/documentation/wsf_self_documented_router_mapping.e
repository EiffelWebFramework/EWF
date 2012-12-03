note
	description: "Summary description for {WSF_SELF_DOCUMENTED_ROUTER_MAPPING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_SELF_DOCUMENTED_ROUTER_MAPPING

inherit
	WSF_ROUTER_MAPPING

feature -- Documentation

	documentation: WSF_ROUTER_MAPPING_DOCUMENTATION
		do
			if attached {WSF_SELF_DOCUMENTED_HANDLER} handler as obj then
				Result := obj.mapping_documentation (Current)
			else
				create Result.make (Current)
			end
		end

end
