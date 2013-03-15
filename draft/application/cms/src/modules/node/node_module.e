note
	description: "Summary description for {NODE_MODULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NODE_MODULE

inherit
	CMS_MODULE

	CMS_HOOK_MENU_ALTER

	CMS_HOOK_BLOCK

create
	make

feature {NONE} -- Initialization

	make
		do
			name := "node"
			version := "1.0"
			description := "Service to manage content based on 'node'"
			package := "core"

			enable
		end

feature {CMS_SERVICE} -- Registration

	service: detachable CMS_SERVICE

	register (a_service: CMS_SERVICE)
		local
			h: CMS_HANDLER
		do
			service := a_service
			a_service.map_uri ("/node/add", agent handle_node_add (a_service, ?, ?))
			a_service.map_uri_template ("/node/add/{type}", agent handle_node_add (a_service, ?, ?))

			create {CMS_HANDLER} h.make (agent handle_node_view (a_service, ?, ?))
			a_service.router.map (create {WSF_URI_TEMPLATE_MAPPING}.make ("/node/{nid}", h))
			a_service.router.map (create {WSF_URI_TEMPLATE_MAPPING}.make ("/node/{nid}/view", h))

			a_service.map_uri_template ("/node/{nid}/edit", agent handle_node_edit (a_service, ?, ?))

			a_service.add_content_type (create {CMS_PAGE_CONTENT_TYPE}.make)

			a_service.add_menu_alter_hook (Current)
			a_service.add_block_hook (Current)
		end

feature -- Hooks

	block_list: ITERABLE [like {CMS_BLOCK}.name]
		do
			Result := <<"node-info">>
		end

	get_block_view (a_block_id: detachable READABLE_STRING_8; a_execution: CMS_EXECUTION)
--		local
--			b: CMS_CONTENT_BLOCK
		do
--			if
--				a_execution.is_front and then
--				attached a_execution.user as u
--			then
--				create b.make ("node-info", "Node", "Node ...", a_execution.formats.plain_text)
--				a_execution.add_block (b, Void)
--			end
		end

	menu_alter (a_menu_system: CMS_MENU_SYSTEM; a_execution: CMS_EXECUTION)
		local
			lnk: CMS_LOCAL_LINK
		do
			if a_execution.authenticated then
				create lnk.make ("Add content", "/node/add/")
				lnk.set_permission_arguments (<<"authenticated">>)
				a_menu_system.navigation_menu.extend (lnk)
			end
		end

	links: HASH_TABLE [CMS_MODULE_LINK, STRING]
			-- Link indexed by path
		do
			create Result.make (0)
		end

	handle_node_view (cms: CMS_SERVICE; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			(create {NODE_VIEW_CMS_EXECUTION}.make (req, res, cms)).execute
		end

	handle_node_edit (cms: CMS_SERVICE; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			(create {NODE_EDIT_CMS_EXECUTION}.make (req, res, cms)).execute
		end

	handle_node_add (cms: CMS_SERVICE; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			(create {NODE_ADD_CMS_EXECUTION}.make (req, res, cms)).execute
		end

end
