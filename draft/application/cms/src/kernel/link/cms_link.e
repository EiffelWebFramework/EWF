note
	description: "Summary description for {CMS_MENU}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_LINK

inherit
	REFACTORING_HELPER

feature -- Access	

	title: READABLE_STRING_32

	location: READABLE_STRING_8

	options: detachable CMS_API_OPTIONS

feature -- status report	

	is_active: BOOLEAN
		deferred
		end

	is_expanded: BOOLEAN
		deferred
		end

	is_expandable: BOOLEAN
		deferred
		end

	has_children: BOOLEAN
		deferred
		end

feature -- Query

	parent: detachable CMS_LINK

	children: detachable LIST [CMS_LINK]
		deferred
		end

end
