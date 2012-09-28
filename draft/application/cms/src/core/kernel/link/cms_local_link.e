note
	description: "Summary description for {CMS_LOCAL_MENU}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_LOCAL_LINK

inherit
	CMS_LINK

create
	make

feature {NONE} -- Initialization

	make (a_title: detachable like title; a_location: like location)
		do
			if a_title /= Void then
				title := a_title
			else
				title := a_location
			end
			location := a_location
		end

feature -- Status report

	is_active: BOOLEAN

	is_expanded: BOOLEAN

	is_expandable: BOOLEAN

	permission_arguments: detachable ITERABLE [STRING]

	children: detachable LIST [CMS_LINK]

feature -- Element change

	set_children (lst: like children)
		do
			children := lst
		end

	set_expanded (b: like is_expanded)
		do
			is_expanded := b
		end

	set_expandable (b: like is_expandable)
		do
			is_expandable := b
		end

	get_is_active (req: WSF_REQUEST)
		do
			is_active := req.path_info.same_string (location)
		end

	set_permission_arguments (args: ITERABLE [STRING])
		do
			permission_arguments := args
		end

	set_options (opts: like options)
		do
			options := opts
		end

end
