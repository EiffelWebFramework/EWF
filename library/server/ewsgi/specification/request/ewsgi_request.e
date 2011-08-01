note
	description: "[
			Server request context of the httpd request
			
			You can create your own descendant of this class to
			add/remove specific value or processing
		]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EWSGI_REQUEST

feature -- Access: Input

	input: EWSGI_INPUT_STREAM
			-- Server input channel
		deferred
		end

feature -- Access: extra values

	request_time: detachable DATE_TIME
			-- Request time (UTC)
		deferred
		end

feature -- Access: environment variables		

	environment: EWSGI_ENVIRONMENT
			-- Environment variables
		deferred
		end

	environment_variable (a_name: STRING): detachable STRING
			-- Environment variable related to `a_name'
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
		deferred
		end

feature -- Access: execution variables		

	execution_variables: EWSGI_VARIABLES [STRING_32]
			-- Execution variables set by the application
		deferred
		end

	execution_variable (a_name: STRING): detachable STRING_32
			-- Execution variable related to `a_name'
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
		deferred
		end

feature -- URL Parameters

	parameters: EWSGI_VARIABLES [STRING_32]
			-- Variables extracted from QUERY_STRING
		deferred
		end

	parameter (a_name: STRING): detachable STRING_32
			-- Parameter for name `n'.
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
		deferred
		end

feature -- Form fields and related

	form_fields: EWSGI_VARIABLES [STRING_32]
			-- Variables sent by POST request
		deferred
		end

	form_field (a_name: STRING): detachable STRING_32
			-- Field for name `a_name'.
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
		deferred
		end

	uploaded_files: HASH_TABLE [EWSGI_UPLOADED_FILE_DATA, STRING]
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

	cookies_variables: HASH_TABLE [STRING, STRING]
			-- Expanded cookies variable
		deferred
		end

	cookies_variable (a_name: STRING): detachable STRING
			-- Field for name `a_name'.
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
		deferred
		end

	cookies: HASH_TABLE [EWSGI_COOKIE, STRING]
			-- Cookies Information
		deferred
		end

feature -- Access: global variable

	variables: HASH_TABLE [STRING_32, STRING_32]
			-- Table containing all the various variables
			-- Warning: this is computed each time, if you change the content of other containers
			-- this won't update this Result's content, unless you query it again
		deferred
		end

	variable (a_name: STRING_8): detachable STRING_32
			-- Variable named `a_name' from any of the variables container
			-- and following a specific order
			-- execution, environment, get, post, cookies
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
		deferred
		end

feature -- Uploaded File Handling

	is_uploaded_file (a_filename: STRING): BOOLEAN
			-- Is `a_filename' a file uploaded via HTTP POST
		deferred
		end

feature -- URL Utility

	absolute_script_url (a_path: STRING): STRING
			-- Absolute Url for the script if any, extended by `a_path'
		deferred
		end

	script_url (a_path: STRING): STRING
			-- Url relative to script name if any, extended by `a_path'
		require
			a_path_attached: a_path /= Void
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
