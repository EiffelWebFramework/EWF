note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	EWF_WIZARD

inherit
	WIZARD

	SHARED_EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
			initialize
			get_information
			if is_valid and attached layout as lay then
				generate_project (lay)
			end
		end

feature -- Access

	project_directory_name: detachable READABLE_STRING_32

	project_directory_path: detachable PATH
		do
			if attached project_directory_name as n then
				create Result.make_from_string (n)
			end
		end

	projet_name: detachable READABLE_STRING_8

	use_router: BOOLEAN

	router_type: detachable READABLE_STRING_8

	connector: detachable READABLE_STRING_8

feature -- Form

	get_information
		local
			e: EXECUTION_ENVIRONMENT
		do
			e := execution_environment
			project_directory_name := e.item ("ISE_PROJECTS")
			if
				attached project_directory_name as pdn and then
				attached string_question ("Project directory (default=" + pdn + ")? ", <<["q", Void]>>, pdn, False) as r_pdn
			then
				project_directory_name := r_pdn.string
			elseif attached string_question ("Project directory ? ", <<["q", Void]>>, Void, False) as r_pdn then
				project_directory_name := r_pdn.string
			end
			if project_directory_name = Void then
				die (-1)
			end

			if attached string_question ("Project name ? ", Void, Void, False) as pn then
				projet_name := pn.string
			else
				projet_name := "ewf"
			end

			if boolean_question ("Do you want to use WSF_ROUTER (Y|n) ? ", <<["y", True], ["Y", True]>>, "Y") then
				use_router := True
				router_type := "uri-template"
			else
				use_router := False
			end

			if attached string_question ("[
				Default connector  ? 
				  1 - Eiffel Web Nino (standalone web server)
				  2 - CGI application (requires to setup httpd server)
				  3 - libFCGI application (requires to setup httpd server)
				Your choice:
				]", <<["1", "nino"], ["2", "cgi"], ["3", "libfcgi"]>>, "1", True) as conn
			then
				connector := conn
			else
				connector := "nino"
			end
		end

	is_valid: BOOLEAN
		do
			Result := project_directory_name /= Void and projet_name /= Void
		end

	generate_project (a_layout: WIZARD_LAYOUT)
		require
			is_valid
		local
			d: DIRECTORY
			dn: PATH
			tfn: PATH
			res: WIZARD_SUCCEED_RESPONSE
		do
			if attached project_directory_path as pdn then
				if attached projet_name as pn then
					variables.force (pn, "TARGET_NAME")
					variables.force (new_uuid, "UUID")
					variables.force ("none", "CONCURRENCY")
					if attached connector as conn then
						variables.force (conn, "EWF_CONNECTOR")
					end
					variables.force ("9999", "EWF_NINO_PORT")

					dn := pdn.extended (pn)
					create d.make_with_path (dn)
					if not d.exists then
						d.recursive_create_dir
					end
					tfn := dn.extended (pn).appended_with_extension ("ecf")
					copy_resource_template ("template.ecf", tfn.name)

					create res.make (tfn, d.path)

					tfn := dn.extended ("ewf").appended_with_extension ("ini")
					copy_resource_template ("ewf.ini", tfn.name)

					dn := pdn.extended (pn).extended ("src")
					create d.make_with_path (dn)
					if not d.exists then
						d.recursive_create_dir
					end

					tfn := dn.extended ("ewf_application").appended_with_extension ("e")
					if attached router_type as rt then
						check rt.same_string ("uri-template") end
						copy_resource_template ("ewf_application-"+ rt +".e", tfn.name)
					else
						copy_resource_template ("ewf_application.e", tfn.name)
					end


					send_response (res)
				end
			end
		end

feature -- Output



feature {NONE} -- Implementation

invariant
--	invariant_clause: True

end
