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
	GW_REQUEST_CONTEXT

feature -- Access: Input/Output

	output: GW_OUTPUT_STREAM
			-- Server output channel
		deferred
		end

	input: GW_INPUT_STREAM
			-- Server input channel
		deferred
		end

feature -- Access: global variable

	variables: HASH_TABLE [STRING_32, STRING_32]
			-- Table containing all the various variables
			-- Warning: this is computed each time, if you change this content of other container
			-- this won't update this Result's content.
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
					s := parameters.variable (n8)
					if s = Void then
						s := form_fields.variable (n8)
						if s = Void then
							s := cookies_variables.item (n8)
						end
					end
				end
			end
			if s /= Void then
				Result := s.as_string_32
			end
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

feature -- Queries

	parameters: GW_REQUEST_VARIABLES
			-- Variables extracted from QUERY_STRING
		deferred
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

	cookies_variables: HASH_TABLE [STRING, STRING]
			-- Expanded cookies variable
		deferred
		end

	cookies: HASH_TABLE [GW_COOKIE, STRING]
			-- Cookies Information
		deferred
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
