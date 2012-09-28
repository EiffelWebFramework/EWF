note
	description: "[
				This class implements the Demo of WEB CMS service

			]"

class
	WEB_CMS

inherit
	CMS_SERVICE
		redefine
			modules
		end

	WSF_DEFAULT_SERVICE
		redefine
			initialize
		end

create
	make_and_launch

feature -- Initialization

	base_url: detachable READABLE_STRING_8

	modules: ARRAYED_LIST [CMS_MODULE]
		local
			m: CMS_MODULE
		once
			Result := Precursor

			-- Others
			create {DEMO_MODULE} m.make (Current)
			m.enable
			Result.extend (m)

			create {SHUTDOWN_MODULE} m.make
			m.enable
			Result.extend (m)

--			create {EIFFEL_LOGIN_MODULE} m.make
--			m.enable
--			Result.extend (m)
		end

feature {NONE} -- Initialization

	initialize
		local
			args: ARGUMENTS
			cfg: detachable STRING
			i,n: INTEGER
			cms_config: CMS_CONFIGURATION
			opts: WSF_SERVICE_LAUNCHER_OPTIONS_FROM_INI
		do
			create args
			from
				i := 1
				n := args.argument_count
			until
				i > n or cfg /= Void
			loop
				if attached args.argument (i) as s then
					if s.same_string ("--config") or s.same_string ("-c") then
						if i < n then
							cfg := args.argument (i + 1)
						end
					end
				end
				i := i + 1
			end
			if cfg = Void then
				if file_exists ("cms.ini") then
					cfg := "cms.ini"
				end
			end
			if cfg /= Void then
				create cms_config.make_from_file (cfg)
--				(create {EXECUTION_ENVIRONMENT}).change_working_directory (dir)
			else
				create cms_config.make
			end

				--| The following line is to be able to load options from the file ewf.ini
			create opts.make_from_file ("ewf.ini")
			service_options := opts

				--| If you don't need any custom options, you are not obliged to redefine `initialize'
			Precursor
			base_url := cms_config.site_base_url (base_url)
			initialize_cms
			site_email := cms_config.site_email (site_email)
			site_name := cms_config.site_name (site_name)

			on_launched
		end

	on_launched
		local
			e: CMS_EMAIL
		do
			create e.make (site_email, site_email, "[" + site_name + "] launched...", "The site [" + site_name + "] was launched at " + (create {DATE_TIME}.make_now_utc).out + " UTC.")
			mailer.safe_process_email (e)
		end

	file_exists (fn: STRING): BOOLEAN
		local
			f: RAW_FILE
		do
			create f.make (fn)
			Result := f.exists and then f.is_readable
		end

end
