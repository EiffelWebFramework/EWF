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

	has_children: BOOLEAN
		do
			Result := attached children as l_children and then not l_children.is_empty
		end

	permission_arguments: detachable ITERABLE [STRING]

	children: detachable LIST [CMS_LINK]

feature -- Element change

	add_link (lnk: CMS_LINK)
		local
			lst: like children
		do
			lst := children
			if lst = Void then
				create {ARRAYED_LIST [CMS_LINK]} lst.make (1)
				children := lst
			end
			lst.force (lnk)
		end

	set_children (lst: like children)
		do
			children := lst
		end

	set_expanded (b: like is_expanded)
		do
			is_expanded := b
			if b then
				is_expandable := True
			end
		end

	set_expandable (b: like is_expandable)
		do
			is_expandable := b
			if not b then
				is_expanded := False
			end
		end

	get_is_active (req: WSF_REQUEST)
		local
			qs: STRING
		do
			create qs.make_from_string (req.path_info)
			if attached req.query_string as l_query_string and then not l_query_string.is_empty then
				qs.append_character ('?')
				qs.append (l_query_string)
			end
			is_active := qs.same_string (location)
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
