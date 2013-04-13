note

	description: "[
						Policies for deciding if a resource that currently doesn't exist used to do so.
						This default implementation assumes that no resources used to exist.
						]"
	date: "$Date$"
	revision: "$Revision$"

class WSF_PREVIOUS_POLICY

feature -- Access

	resource_previously_existed (req: WSF_REQUEST) : BOOLEAN
			-- Did `req.path_translated' exist previously?
		require
			req_attached: req /= Void
		do
			-- No. Override if this is not want you want.
		end

	resource_moved_permanently (req: WSF_REQUEST) : BOOLEAN
			-- Was `req.path_translated' moved permanently?
		require
			req_attached: req /= Void
			previously_existed: resource_previously_existed (req)
		do
			-- No. Override if this is not want you want.
		end

	resource_moved_temporarily (req: WSF_REQUEST) : BOOLEAN
			-- Was `req.path_translated' moved temporarily?
		require
			req_attached: req /= Void
			previously_existed: resource_previously_existed (req)
		do
			-- No. Override if this is not want you want.
		end

end
