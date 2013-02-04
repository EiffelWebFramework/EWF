note
	description: "[
				This class implements the CMS service

				It could be used to implement the main EWF service, or
				even for a specific handler.
			]"

deferred class
	CMS_SERVICE

feature -- Initialization

	initialize_cms (a_cfg: detachable CMS_CONFIGURATION)
		local
			cfg: detachable CMS_CONFIGURATION
		do
			cfg := a_cfg
			if cfg = Void then
				create cfg.make
			end

			site_url := "" -- Fixme
			site_name := cfg.site_name ("EWF::CMS")
			site_email := cfg.site_email ("webmaster")
			site_dir := cfg.root_location
			site_var_dir := cfg.var_location
			files_location := cfg.files_location
			themes_location := cfg.themes_location
			theme_name := cfg.theme_name ("default")

			compute_theme_resource_location


			create content_types.make (3)
			initialize_storage
			initialize_auth_engine
			initialize_session_manager
			initialize_mailer
			initialize_router
			initialize_modules
		end

	initialize_session_manager
		local
			dn: DIRECTORY_NAME
		do
			create dn.make_from_string (site_var_dir)
			dn.extend ("_storage_")
			dn.extend ("_sessions_")
			create {WSF_FS_SESSION_MANAGER} session_manager.make_with_folder (dn.string)
		end

	initialize_storage
		local
			dn: DIRECTORY_NAME
--			u: CMS_USER
		do
			create dn.make_from_string (site_var_dir)
			dn.extend ("_storage_")
			create {CMS_SED_STORAGE} storage.make (dn.string)
			if not storage.has_user then
				initialize_users
			end
		end

	initialize_users
		require
			has_no_user: not storage.has_user
		local
			u: CMS_USER
		do
			create u.make_new ("admin")
			u.set_password ("istrator")
			storage.save_user (u)
		end

	initialize_mailer
		local
			ch_mailer: CMS_CHAIN_MAILER
			st_mailer: CMS_STORAGE_MAILER
		do
			create st_mailer.make (storage)
			create ch_mailer.make (st_mailer)
			ch_mailer.set_next (create {CMS_SENDMAIL_MAILER})
			mailer := ch_mailer
		end

	initialize_router
		local
--			h: CMS_HANDLER
			file_hdl: CMS_FILE_SYSTEM_HANDLER
			dn: DIRECTORY_NAME
		do
			create router.make (10)
			router.set_base_url (base_url)

			router.map (create {WSF_URI_MAPPING}.make ("/", create {CMS_HANDLER}.make (agent handle_home)))
			router.map (create {WSF_URI_MAPPING}.make ("/favicon.ico", create {CMS_HANDLER}.make (agent handle_favicon)))

			create file_hdl.make (files_location)
			file_hdl.disable_index
			file_hdl.set_max_age (8*60*60)
			router.map (create {WSF_STARTS_WITH_MAPPING}.make ("/files/", file_hdl))

			create dn.make_from_string (theme_resource_location)
			create file_hdl.make (theme_resource_location)
			file_hdl.set_max_age (8*60*60)
			router.map (create {WSF_STARTS_WITH_MAPPING}.make ("/theme/", file_hdl))
		end

	initialize_modules
		do
			across
				modules as m
			loop
				if m.item.is_enabled then
					m.item.register (Current)
					if attached {CMS_HOOK_AUTO_REGISTER} m.item as h_auto then
						h_auto.hook_auto_register (Current)
					end
				end
			end
		end

	initialize_auth_engine
		do
			create {CMS_STORAGE_AUTH_ENGINE} auth_engine.make (storage)
		end

feature -- Access	

	auth_engine: CMS_AUTH_ENGINE

	modules: ARRAYED_LIST [CMS_MODULE]
		local
			m: CMS_MODULE
		once
			create Result.make (10)
			-- Core
			create {USER_MODULE} m.make (Current)
			m.enable
			Result.extend (m)

			create {ADMIN_MODULE} m.make (Current)
			m.enable
			Result.extend (m)

			create {NODE_MODULE} m.make (Current)
			m.enable
			Result.extend (m)
		end

feature -- Hook: menu_alter

	add_menu_alter_hook (h: like menu_alter_hooks.item)
		local
			lst: like menu_alter_hooks
		do
			lst := menu_alter_hooks
			if lst = Void then
				create lst.make (1)
				menu_alter_hooks := lst
			end
			lst.force (h)
		end

	menu_alter_hooks: detachable ARRAYED_LIST [CMS_HOOK_MENU_ALTER]

	call_menu_alter_hooks (m: CMS_MENU_SYSTEM; a_execution: CMS_EXECUTION)
		do
			if attached menu_alter_hooks as lst then
				across
					lst as c
				loop
					c.item.menu_alter (m, a_execution)
				end
			end
		end

feature -- Hook: form_alter

	add_form_alter_hook (h: like form_alter_hooks.item)
		local
			lst: like form_alter_hooks
		do
			lst := form_alter_hooks
			if lst = Void then
				create lst.make (1)
				form_alter_hooks := lst
			end
			lst.force (h)
		end

	form_alter_hooks: detachable ARRAYED_LIST [CMS_HOOK_FORM_ALTER]

	call_form_alter_hooks (f: CMS_FORM; a_execution: CMS_EXECUTION)
		do
			if attached form_alter_hooks as lst then
				across
					lst as c
				loop
					c.item.form_alter (f, a_execution)
				end
			end
		end

feature -- Hook: block		

	add_block_hook (h: like block_hooks.item)
		local
			lst: like block_hooks
		do
			lst := block_hooks
			if lst = Void then
				create lst.make (1)
				block_hooks := lst
			end
			lst.force (h)
		end

	block_hooks: detachable ARRAYED_LIST [CMS_HOOK_BLOCK]

	hook_block_view (a_execution: CMS_EXECUTION)
		do
			if attached block_hooks as lst then
				across
					lst as c
				loop
					across
						c.item.block_list as blst
					loop
						c.item.get_block_view (blst.item, a_execution)
					end
				end
			end
		end

feature -- Router

	site_name: READABLE_STRING_32

	site_email: READABLE_STRING_8

	site_url: READABLE_STRING_8

	site_dir: READABLE_STRING_8

	site_var_dir: READABLE_STRING_8

	files_location: READABLE_STRING_8

	themes_location: READABLE_STRING_8

	compute_theme_resource_location
		local
			dn: DIRECTORY_NAME
		do
			create dn.make_from_string (themes_location)
			dn.extend (theme_name)
			dn.extend ("res")
			theme_resource_location := dn.string
		end

	theme_resource_location: READABLE_STRING_8

	theme_name: READABLE_STRING_32

	front_path: STRING
		do
			if attached base_url as l_base_url then
				Result := l_base_url + "/"
			else
				Result := "/"
			end
		end

	router: WSF_ROUTER

	base_url: detachable READABLE_STRING_8
			-- Base url (related to the script path).
		deferred
		ensure
			valid_base_url: (Result /= Void and then Result.is_empty) implies (Result.starts_with ("/") and not Result.ends_with ("/"))
		end

	server_base_url: detachable READABLE_STRING_8
			-- Base url (related to absolute path).
		deferred
		ensure
			valid_base_url: (Result /= Void and then Result.is_empty) implies (Result.starts_with ("/") and not Result.ends_with ("/"))
		end

	map_uri_template (tpl: STRING; proc: PROCEDURE [ANY, TUPLE [req: WSF_REQUEST; res: WSF_RESPONSE]])
		do
			router.map (create {WSF_URI_TEMPLATE_MAPPING}.make_from_template (tpl, create {CMS_HANDLER}.make (proc)))
		end

	map_uri (a_uri: STRING; proc: PROCEDURE [ANY, TUPLE [req: WSF_REQUEST; res: WSF_RESPONSE]])
		do
			router.map (create {WSF_URI_MAPPING}.make (a_uri, create {CMS_HANDLER}.make (proc)))
		end

feature -- Report

	is_front_page (req: WSF_REQUEST): BOOLEAN
		do
			Result := req.path_info.same_string (front_path)
		end

feature {CMS_EXECUTION, CMS_MODULE} -- Security report

	user_has_permission (u: detachable CMS_USER; s: detachable READABLE_STRING_8): BOOLEAN
			-- Anonymous or user `u' has permission for `s' ?
			--| `s' could be "create page",	
		do
			Result := storage.user_has_permission (u, s)
		end

feature -- Storage

	session_controller (req: WSF_REQUEST): CMS_SESSION_CONTROLER
			-- New session controller for request `req'
		do
			create Result.make (req, session_manager)
		end

	session_manager: WSF_SESSION_MANAGER
			-- CMS Session manager

	storage: CMS_STORAGE

feature -- Logging

	log	(a_category: READABLE_STRING_8; a_message: READABLE_STRING_8; a_level: INTEGER; a_link: detachable CMS_LINK)
		local
			l_log: CMS_LOG
		do
			create l_log.make (a_category, a_message, a_level, Void)
			if a_link /= Void then
				l_log.set_link (a_link)
			end
			storage.save_log (l_log)
		end

feature -- Content type

	content_types: ARRAYED_LIST [CMS_CONTENT_TYPE]
			-- Available content types

	add_content_type (a_type: CMS_CONTENT_TYPE)
		do
			content_types.force (a_type)
		end

	content_type (a_name: READABLE_STRING_8): detachable CMS_CONTENT_TYPE
		do
			across
				content_types as t
			until
				Result /= Void
			loop
				if t.item.name.same_string (a_name) then
					Result := t.item
				end
			end
		end

feature -- Notification

	mailer: CMS_MAILER

feature -- Core Execution

	handle_favicon (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			fres: WSF_FILE_RESPONSE
			fn: FILE_NAME
		do
			create fn.make_from_string (theme_resource_location)
			fn.set_file_name ("favicon.ico")
			create fres.make (fn.string)
			fres.set_expires_in_seconds (7 * 24 * 60 * 60) -- 7 jours
			res.send (fres)
		end

	handle_home (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			(create {HOME_CMS_EXECUTION}.make (req, res, Current)).execute
		end

--	handle_theme (req: WSF_REQUEST; res: WSF_RESPONSE)
--		do
--			(create {THEME_CMS_EXECUTION}.make (req, res, Current)).execute
--		end

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Default request handler if no other are relevant
		local
			e: CMS_EXECUTION
--			not_found: WSF_NOT_FOUND_RESPONSE
		do
			if site_url.is_empty then
				site_url := req.absolute_script_url ("")
			end
			if attached router.dispatch_and_return_handler (req, res) as p then
				-- ok
			else
				create {NOT_FOUND_CMS_EXECUTION} e.make (req, res, Current)
				e.execute
--				create not_found.make
--				res.send (not_found)
			end
		end

end
