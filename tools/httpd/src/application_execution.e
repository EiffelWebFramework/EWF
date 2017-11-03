note
	description : "simple application execution"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION_EXECUTION

inherit
	WSF_ROUTED_EXECUTION

	SHARED_EXECUTION_ENVIRONMENT

create
	make

feature -- Setup

	cgi_file_extensions: ITERABLE [READABLE_STRING_GENERAL]
		once
			Result := <<"cgi">>
		end

	directory_index_file_names: ITERABLE [READABLE_STRING_GENERAL]
		once
			Result := <<"index.html">>
		end

	document_location: PATH
			-- Root folder for the httpd files server.
		local
			i,n: INTEGER
			d: detachable READABLE_STRING_GENERAL
		once
			Result := execution_environment.current_working_path.extended ("www")
			if attached execution_environment.arguments as args then
				from
					i := 1
					n := args.argument_count
				until
					i > n or d /= Void
				loop
					if
						attached args.argument (i) as v and then
						v.same_string_general ("--root") and then
						i < n
					then
						i := i + 1
						d := args.argument (i)
					end
					i := i + 1
				end
				if d /= Void then
					create Result.make_from_string (d)
				end
			end
		end

	setup_router
			-- Setup `router'
		local
			cgi: WSF_CGI_HANDLER
			cgi_cond: WSF_ROUTING_CONDITION
			fs: WSF_FILE_SYSTEM_HANDLER
			m: WSF_STARTS_WITH_MAPPING
			cond: WSF_WITH_CONDITION_MAPPING
			s: STRING_32
		do
			create cgi.make (document_location)
			cgi_cond := create {WSF_ROUTING_FILE_EXISTS_CONDITION}.make (document_location) and create {WSF_ROUTING_EXTENSION_CONDITION}.make (cgi_file_extensions)
			create cond.make (cgi_cond, cgi)
			create s.make_empty
			across
				cgi_file_extensions as ic
			loop
				if not s.is_empty then
					s.append_string_general (", ")
				end
				s.append_string_general ("*.")
				s.append_string_general (ic.item)
			end
			cond.set_condition_description (s)

			router.map (cond, Void)

			create fs.make_with_path (document_location)
			fs.enable_index
			fs.set_directory_index (directory_index_file_names)
			fs.set_not_found_handler (agent (i_uri: READABLE_STRING_8; req: WSF_REQUEST; res: WSF_RESPONSE) do execute_default (req, res) end)

			create m.make ("", fs)
			router.map (m, router.methods_get)
		end

end
