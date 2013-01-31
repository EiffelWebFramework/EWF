note
	description: "Summary description for {ADMIN_MODULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ADMIN_MODULE

inherit
	CMS_MODULE

	CMS_HOOK_MENU_ALTER

create
	make

feature {NONE} -- Initialization

	make (a_service: like service)
		do
			service := a_service
			name := "admin"
			version := "1.0"
			description := "Set of service to administrate the site"
			package := "core"

			enable
		end

feature {CMS_SERVICE} -- Registration

	service: CMS_SERVICE

	register (a_service: CMS_SERVICE)
		do
			a_service.map_uri ("/admin/", agent handle_admin)
			a_service.map_uri ("/admin/users/", agent handle_admin_users)
			a_service.map_uri ("/admin/blocks/", agent handle_admin_blocks)
			a_service.map_uri ("/admin/modules/", agent handle_admin_modules)
			a_service.map_uri ("/admin/logs/", agent handle_admin_logs)
			a_service.map_uri_template ("/admin/log/{log-id}", agent handle_admin_log_view)

			a_service.add_menu_alter_hook (Current)
		end

feature -- Hooks

	menu_alter (a_menu_system: CMS_MENU_SYSTEM; a_execution: CMS_EXECUTION)
		local
			lnk: CMS_LOCAL_LINK
		do
			create lnk.make ("Administer", "/admin/")
			lnk.set_permission_arguments (<<"administer">>)
			a_menu_system.management_menu.extend (lnk)
		end

	links: HASH_TABLE [CMS_MODULE_LINK, STRING]
			-- Link indexed by path
		local
--			lnk: CMS_MODULE_LINK
		do
			create Result.make (3)
--			create lnk.make ("Date/time demo")
--			lnk.set_callback (agent process_date_time_demo, <<"arg">>)
--			Result["/demo/date/{arg}"] := lnk
		end

	handle_admin (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			(create {ADMIN_CMS_EXECUTION}.make (req, res, service)).execute
		end

	handle_admin_users (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			(create {ADMIN_USERS_CMS_EXECUTION}.make (req, res, service)).execute
		end

	handle_admin_blocks (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			(create {ADMIN_BLOCKS_CMS_EXECUTION}.make (req, res, service)).execute
		end

	handle_admin_modules (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			(create {ADMIN_MODULES_CMS_EXECUTION}.make (req, res, service)).execute
		end

	handle_admin_logs (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			(create {ADMIN_LOGS_CMS_EXECUTION}.make (req, res, service)).execute
		end

	handle_admin_log_view (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			(create {LOG_VIEW_CMS_EXECUTION}.make (req, res, service)).execute
		end


end
