note
	description: "[
			Server request context of the httpd request
			
			You can create your own descendant of this class to
			add/remove specific value or processing
			
			This object is created by {GW_APPLICATION}.new_request_context
		]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GW_REQUEST

feature -- Access: Input

	input: GW_INPUT_STREAM
			-- Server input channel
		deferred
		end

feature -- Access: extra values

	request_time: detachable DATE_TIME
			-- Request time (UTC)
		deferred
		end

feature -- Access: environment variables		

	environment: GW_ENVIRONMENT
			-- Environment variables
		deferred
		end

	environment_variable (a_name: STRING): detachable STRING
			-- Environment variable related to `a_name'
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
		do
			Result := environment.variable (a_name)
		end

feature -- Access: execution variables		

	execution_variables: GW_EXECUTION_VARIABLES
			-- Execution variables set by the application
		deferred
		end

	execution_variable (a_name: STRING): detachable STRING_32
			-- Execution variable related to `a_name'
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
		do
			Result := execution_variables.variable (a_name)
		end

feature -- URL Parameters

	parameter (n: STRING): detachable STRING_32
			-- Parameter for name `n'.
		do
			Result := parameters.variable (n)
		end

	parameters: GW_REQUEST_VARIABLES
			-- Variables extracted from QUERY_STRING
		deferred
		end

feature -- Form fields and related

	form_field (n: STRING): detachable STRING_32
			-- Field for name `n'.
		do
			Result := form_fields.variable (n)
		end

	form_fields: GW_REQUEST_VARIABLES
			-- Variables sent by POST request
		deferred
		end

	uploaded_files: HASH_TABLE [TUPLE [name: STRING; type: STRING; tmp_name: STRING; tmp_basename: STRING; error: INTEGER; size: INTEGER], STRING]
			-- Table of uploaded files information
			--| name: original path from the user
			--| type: content type
			--| tmp_name: path to temp file that resides on server
			--| tmp_base_name: basename of `tmp_name'
			--| error: if /= 0 , there was an error : TODO ...
			--| size: size of the file given by the http request
		deferred
		end

feature -- Cookies	

	cookies_variable (n: STRING): detachable STRING
			-- Field for name `n'.
		do
			Result := cookies_variables.item (n)
		end

	cookies_variables: HASH_TABLE [STRING, STRING]
			-- Expanded cookies variable
		deferred
		end

	cookies: HASH_TABLE [GW_COOKIE, STRING]
			-- Cookies Information
		deferred
		end

feature -- Access: global variable

	variables: HASH_TABLE [STRING_32, STRING_32]
			-- Table containing all the various variables
			-- Warning: this is computed each time, if you change the content of other containers
			-- this won't update this Result's content, unless you query it again
		local
			vars: HASH_TABLE [STRING_GENERAL, STRING_GENERAL]
		do
			create Result.make (100)

			vars := execution_variables
			from
				vars.start
			until
				vars.after
			loop
				Result.put (vars.item_for_iteration, vars.key_for_iteration)
				vars.forth
			end

			vars := environment.table
			from
				vars.start
			until
				vars.after
			loop
				Result.put (vars.item_for_iteration, vars.key_for_iteration)
				vars.forth
			end

			vars := parameters.table
			from
				vars.start
			until
				vars.after
			loop
				Result.put (vars.item_for_iteration, vars.key_for_iteration)
				vars.forth
			end

			vars := form_fields.table
			from
				vars.start
			until
				vars.after
			loop
				Result.put (vars.item_for_iteration, vars.key_for_iteration)
				vars.forth
			end

			vars := cookies_variables
			from
				vars.start
			until
				vars.after
			loop
				Result.put (vars.item_for_iteration, vars.key_for_iteration)
				vars.forth
			end
		end

	variable (n8: STRING_8): detachable STRING_32
			-- Variable named `n' from any of the variables container
			-- and following a specific order
			-- execution, environment, get, post, cookies
		local
			s: detachable STRING_GENERAL
		do
			s := execution_variable (n8)
			if s = Void then
				s := environment_variable (n8)
				if s = Void then
					s := parameter (n8)
					if s = Void then
						s := form_field (n8)
						if s = Void then
							s := cookies_variable (n8)
						end
					end
				end
			end
			if s /= Void then
				Result := s.as_string_32
			end
		end

feature -- Uploaded File Handling

	move_uploaded_file (a_filename: STRING; a_destination: STRING): BOOLEAN
			-- Move uploaded file `a_filename' to `a_destination'
			--| if this is not an uploaded file, do not move it.
		require
			a_filename_valid: a_filename /= Void and then not a_filename.is_empty
			a_destination_valid: a_destination /= Void and then not a_destination.is_empty
		deferred
		end

	is_uploaded_file (a_filename: STRING): BOOLEAN
			-- Is `a_filename' a file uploaded via HTTP POST
		deferred
		end

feature {NONE} -- Temporary File handling		

	delete_uploaded_file (a_filename: STRING)
			-- Delete file `a_filename'
		require
			a_filename_valid: a_filename /= Void and then not a_filename.is_empty
		deferred
		end

feature -- URL Utility

	absolute_script_url (a_path: STRING): STRING
			-- Absolute Url for the script if any, extended by `a_path'
		do
			Result := script_url (a_path)
			if attached environment.http_host as h then
				Result.prepend (h)
			else
				--| Issue ??
			end
		end

	script_url (a_path: STRING): STRING
			-- Url relative to script name if any, extended by `a_path'
		require
			a_path_attached: a_path /= Void
		local
			l_base_url: like internal_url_base
			i,m,n: INTEGER
			l_rq_uri: like environment.request_uri
			env: like environment
		do
			l_base_url := internal_url_base
			if l_base_url = Void then
				env := environment
				if attached env.script_name as l_script_name then
					l_rq_uri := env.request_uri
					if l_rq_uri.starts_with (l_script_name) then
						l_base_url := l_script_name
					else
						--| Handle Rewrite url engine, to have clean path
						from
							i := 1
							m := l_rq_uri.count
							n := l_script_name.count
						until
							i > m or i > n or l_rq_uri[i] /= l_script_name[i]
						loop
							i := i + 1
						end
						if i > 1 then
							if l_rq_uri[i-1] = '/' then
								i := i -1
							end
							l_base_url := l_rq_uri.substring (1, i - 1)
						end
					end
				end
				if l_base_url = Void then
					create l_base_url.make_empty
				end
				internal_url_base := l_base_url
			end
			Result := l_base_url + a_path
		end

feature {NONE} -- Implementation: URL Utility

	internal_url_base: detachable STRING
			-- URL base of potential script

invariant

note
	copyright: "2011-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
