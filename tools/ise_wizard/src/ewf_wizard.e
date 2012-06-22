note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	EWF_WIZARD

inherit
	WIZARD

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

feature -- Status

feature -- Access

	project_directory_name: detachable READABLE_STRING_8

	projet_name: detachable READABLE_STRING_8

	use_router: BOOLEAN

	router_type: detachable READABLE_STRING_8

	connector: detachable READABLE_STRING_8

feature -- Form

	get_information
		local
			e: EXECUTION_ENVIRONMENT
		do
			create e
			project_directory_name := e.get ("ISE_PROJECTS")
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

			if boolean_question ("Do you want to use router (Y|n) ? ", <<["y", True], ["Y", True]>>, "Y") then
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
			dn: DIRECTORY_NAME
			tfn: FILE_NAME
			res: WIZARD_SUCCEED_RESPONSE
		do
			if attached project_directory_name as pdn then
				if attached projet_name as pn then
					variables.force (pn, "TARGET_NAME")
					variables.force (new_uuid, "UUID")
					variables.force ("none", "CONCURRENCY")
					if attached connector as conn then
						variables.force (conn, "EWF_CONNECTOR")
					end
					variables.force ("9999", "EWF_NINO_PORT")

					create dn.make_from_string (pdn)
					dn.extend (pn)
					create d.make (dn.string)
					if not d.exists then
						d.recursive_create_dir
					end
					create tfn.make_from_string (dn.string)
					tfn.set_file_name (pn)
					tfn.add_extension ("ecf")
					copy_resource_template ("template.ecf", tfn.string)

					create res.make (tfn.string, d.name)

					create dn.make_from_string (pdn)
					dn.extend (pn)
					dn.extend ("src")
					create d.make (dn.string)
					if not d.exists then
						d.recursive_create_dir
					end
					create tfn.make_from_string (dn.string)
					tfn.set_file_name ("ewb_application")
					tfn.add_extension ("e")
					if attached router_type as rt then
						check rt.same_string ("uri-template") end
						copy_resource_template ("ewb_application-"+ rt +".e", tfn.string)
					else
						copy_resource_template ("ewb_application.e", tfn.string)
					end

					create tfn.make_from_string (dn.string)

					tfn.set_file_name ("ewf")
					tfn.add_extension ("ini")
					copy_resource_template ("ewf.ini", tfn.string)

					send_response (res)
				end
			end
		end

feature -- Output



feature {NONE} -- Implementation

invariant
--	invariant_clause: True

end
