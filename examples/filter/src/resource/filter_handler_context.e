note
	description: "Custom handler context."
	author: "Olivier Ligot"
	date: "$Date$"
	revision: "$Revision$"

class
	FILTER_HANDLER_CONTEXT

inherit
	WSF_HANDLER_CONTEXT
		redefine
			mapping
		end

create
	make

feature -- Access

	mapping: FILTER_CONTEXT_MAPPING
			-- Associated mapping

	user: detachable USER
			-- Authenticated user

feature -- Element change

	set_user (a_user: USER)
			-- Set `user' to `a_user'
		do
			user := a_user
		ensure
			user_set: user = a_user
		end

end
