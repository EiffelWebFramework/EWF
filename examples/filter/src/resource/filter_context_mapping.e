note
	description: "Summary description for {FILTER_CONTEXT_MAPPING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FILTER_CONTEXT_MAPPING

inherit
	WSF_URI_TEMPLATE_CONTEXT_MAPPING
		redefine
			context
		end

create
	make,
	make_from_template

feature {NONE} -- Implementation

	context (req: WSF_REQUEST; map: FILTER_CONTEXT_MAPPING): FILTER_HANDLER_CONTEXT
		do
			create {FILTER_HANDLER_CONTEXT} Result.make (req, map)
		end

end
