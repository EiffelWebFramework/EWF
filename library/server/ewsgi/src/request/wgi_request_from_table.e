note
	description: "[
				Request instanciated from a hash_table of meta variables
		]"
	specification: "EWSGI specification https://github.com/Eiffel-World/Eiffel-Web-Framework/wiki/EWSGI-specification"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	WGI_REQUEST_FROM_TABLE

inherit
	WGI_REQUEST

create
	make

feature {NONE} -- Initialization

	make (a_vars: HASH_TABLE [READABLE_STRING_8, READABLE_STRING_8]; a_input: like input)
		require
			vars_attached: a_vars /= Void
		do
			create error_handler.make
			input := a_input
			set_meta_parameters (a_vars)
			create uploaded_files.make (0)

			raw_post_data_recorded := True

			initialize
			analyze
		end

	set_meta_parameters (a_vars: HASH_TABLE [READABLE_STRING_8, READABLE_STRING_GENERAL])
			-- Fill with variable from `a_vars'
		local
			s: like meta_string_variable
			table: HASH_TABLE [WGI_VALUE, READABLE_STRING_GENERAL]
		do
			create {STRING_32} empty_string.make_empty

			create table.make (a_vars.count)
			meta_variables_table := table
			from
				a_vars.start
			until
				a_vars.after
			loop
				table.force (new_string_value (a_vars.key_for_iteration, a_vars.item_for_iteration), a_vars.key_for_iteration)
				a_vars.forth
			end

				--| QUERY_STRING
			query_string := meta_string_variable_or_default ({WGI_META_NAMES}.query_string, empty_string, False)

				--| REQUEST_METHOD
			request_method := meta_string_variable_or_default ({WGI_META_NAMES}.request_method, empty_string, False)

				--| CONTENT_TYPE
			s := meta_string_variable ({WGI_META_NAMES}.content_type)
			if s /= Void and then not s.is_empty then
				content_type := s
			else
				content_type := Void
			end

				--| CONTENT_LENGTH
			s := meta_string_variable ({WGI_META_NAMES}.content_length)
			content_length := s
			if s /= Void and then s.is_natural_64 then
				content_length_value := s.to_natural_64
			else
				--| content_length := 0
			end

				--| PATH_INFO
			path_info := meta_string_variable_or_default ({WGI_META_NAMES}.path_info, empty_string, False)

				--| SERVER_NAME
			server_name := meta_string_variable_or_default ({WGI_META_NAMES}.server_name, empty_string, False)

				--| SERVER_PORT
			s := meta_string_variable ({WGI_META_NAMES}.server_port)
			if s /= Void and then s.is_integer then
				server_port := s.to_integer
			else
				server_port := 80
			end

				--| SCRIPT_NAME
			script_name := meta_string_variable_or_default ({WGI_META_NAMES}.script_name, empty_string, False)

				--| REMOTE_ADDR
			remote_addr := meta_string_variable_or_default ({WGI_META_NAMES}.remote_addr, empty_string, False)

				--| REMOTE_HOST
			remote_host := meta_string_variable_or_default ({WGI_META_NAMES}.remote_host, empty_string, False)

				--| REQUEST_URI
			request_uri := meta_string_variable_or_default ({WGI_META_NAMES}.request_uri, empty_string, False)
		end

	initialize
			-- Specific initialization
		local
			p: INTEGER
		do
				--| Here one can set its own environment entries if needed

				--| do not use `force', to avoid overwriting existing variable
			if attached request_uri as rq_uri then
				p := rq_uri.index_of ('?', 1)
				if p > 0 then
					set_meta_string_variable (rq_uri.substring (1, p-1), {WGI_META_NAMES}.self)
				else
					set_meta_string_variable (rq_uri, {WGI_META_NAMES}.self)
				end
			end
			if meta_variable ({WGI_META_NAMES}.request_time) = Void then
				set_meta_string_variable (date_time_utilities.unix_time_stamp (Void).out, {WGI_META_NAMES}.request_time)
			end
		end

	analyze
			-- Analyze context, set various attributes and validate values
		do
			extract_variables
		end

feature -- Status

	raw_post_data_recorded: BOOLEAN assign set_raw_post_data_recorded
			-- Record RAW POST DATA in meta parameters
			-- otherwise just forget about it
			-- Default: true
			--| warning: you might keep in memory big amount of memory ...

feature -- Error handling

	has_error: BOOLEAN
		do
			Result := error_handler.has_error
		end

	error_handler: ERROR_HANDLER
			-- Error handler
			-- By default initialized to new handler

feature -- Access: Input

	input: WGI_INPUT_STREAM
			-- Server input channel

feature -- Access extra information

	request_time: detachable DATE_TIME
			-- Request time (UTC)
		do
			if
				attached {WGI_STRING_VALUE} meta_variable ({WGI_META_NAMES}.request_time) as t and then
				t.string.is_integer_64
			then
				Result := date_time_utilities.unix_time_stamp_to_date_time (t.string.to_integer_64)
			end
		end

feature {NONE} -- Access: CGI meta parameters

	meta_variables_table: HASH_TABLE [WGI_VALUE, READABLE_STRING_GENERAL]
			-- CGI Environment parameters

feature -- Access: CGI meta parameters

	meta_variables: ITERATION_CURSOR [WGI_VALUE]
		do
			Result := meta_variables_table.new_cursor
		end

	meta_variable (a_name: READABLE_STRING_GENERAL): detachable WGI_VALUE
			-- CGI meta variable related to `a_name'
		do
			Result := meta_variables_table.item (a_name)
		end

	meta_string_variable (a_name: READABLE_STRING_GENERAL): detachable READABLE_STRING_32
			-- CGI meta variable related to `a_name'
		do
			if attached meta_variables_table.item (a_name) as val then
				Result := val.as_string
			end
		end

	meta_string_variable_or_default (a_name: READABLE_STRING_GENERAL; a_default: READABLE_STRING_32; use_default_when_empty: BOOLEAN): READABLE_STRING_32
			-- Value for meta parameter `a_name'
			-- If not found, return `a_default'
		require
			a_name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			if attached meta_variable (a_name) as val then
				Result := val.as_string
				if use_default_when_empty and then Result.is_empty then
					Result := a_default
				end
			else
				Result := a_default
			end
		end

	set_meta_string_variable (a_name: READABLE_STRING_GENERAL; a_value: READABLE_STRING_32)
		do
			meta_variables_table.force (new_string_value (a_name, a_value), a_name)
		ensure
			param_set: attached {WGI_STRING_VALUE} meta_variable (a_name) as val and then val ~ a_value
		end

	unset_meta_variable (a_name: READABLE_STRING_GENERAL)
		do
			meta_variables_table.remove (a_name)
		ensure
			param_unset: meta_variable (a_name) = Void
		end

feature -- Access: CGI meta parameters - 1.1

	auth_type: detachable READABLE_STRING_32

	content_length: detachable READABLE_STRING_32

	content_length_value: NATURAL_64

	content_type: detachable READABLE_STRING_32

	gateway_interface: READABLE_STRING_32
		do
			Result := meta_string_variable_or_default ({WGI_META_NAMES}.gateway_interface, "", False)
		end

	path_info: READABLE_STRING_32
			-- <Precursor/>
			--
			--| For instance, if the current script was accessed via the URL
			--| http://www.example.com/eiffel/path_info.exe/some/stuff?foo=bar, then $_SERVER['PATH_INFO'] would contain /some/stuff.
			--|
			--| Note that is the PATH_INFO variable does not exists, the `path_info' value will be empty

	path_translated: detachable READABLE_STRING_32
		do
			Result := meta_string_variable ({WGI_META_NAMES}.path_translated)
		end

	query_string: READABLE_STRING_32

	remote_addr: READABLE_STRING_32

	remote_host: READABLE_STRING_32

	remote_ident: detachable READABLE_STRING_32
		do
			Result := meta_string_variable ({WGI_META_NAMES}.remote_ident)
		end

	remote_user: detachable READABLE_STRING_32
		do
			Result := meta_string_variable ({WGI_META_NAMES}.remote_user)
		end

	request_method: READABLE_STRING_32

	script_name: READABLE_STRING_32

	server_name: READABLE_STRING_32

	server_port: INTEGER

	server_protocol: READABLE_STRING_32
		do
			Result := meta_string_variable_or_default ({WGI_META_NAMES}.server_protocol, "HTTP/1.0", True)
		end

	server_software: READABLE_STRING_32
		do
			Result := meta_string_variable_or_default ({WGI_META_NAMES}.server_software, "Unknown Server", True)
		end

feature -- Access: HTTP_* CGI meta parameters - 1.1

	http_accept: detachable READABLE_STRING_32
			-- Contents of the Accept: header from the current request, if there is one.
		do
			Result := meta_string_variable ({WGI_META_NAMES}.http_accept)
		end

	http_accept_charset: detachable READABLE_STRING_32
			-- Contents of the Accept-Charset: header from the current request, if there is one.
			-- Example: 'iso-8859-1,*,utf-8'.
		do
			Result := meta_string_variable ({WGI_META_NAMES}.http_accept_charset)
		end

	http_accept_encoding: detachable READABLE_STRING_32
			-- Contents of the Accept-Encoding: header from the current request, if there is one.
			-- Example: 'gzip'.
		do
			Result := meta_string_variable ({WGI_META_NAMES}.http_accept_encoding)
		end

	http_accept_language: detachable READABLE_STRING_32
			-- Contents of the Accept-Language: header from the current request, if there is one.
			-- Example: 'en'.
		do
			Result := meta_string_variable ({WGI_META_NAMES}.http_accept_language)
		end

	http_connection: detachable READABLE_STRING_32
			-- Contents of the Connection: header from the current request, if there is one.
			-- Example: 'Keep-Alive'.
		do
			Result := meta_string_variable ({WGI_META_NAMES}.http_connection)
		end

	http_host: detachable READABLE_STRING_32
			-- Contents of the Host: header from the current request, if there is one.
		do
			Result := meta_string_variable ({WGI_META_NAMES}.http_host)
		end

	http_referer: detachable READABLE_STRING_32
			-- The address of the page (if any) which referred the user agent to the current page.
			-- This is set by the user agent.
			-- Not all user agents will set this, and some provide the ability to modify HTTP_REFERER as a feature.
			-- In short, it cannot really be trusted.
		do
			Result := meta_string_variable ({WGI_META_NAMES}.http_referer)
		end

	http_user_agent: detachable READABLE_STRING_32
			-- Contents of the User-Agent: header from the current request, if there is one.
			-- This is a string denoting the user agent being which is accessing the page.
			-- A typical example is: Mozilla/4.5 [en] (X11; U; Linux 2.2.9 i586).
			-- Among other things, you can use this value to tailor your page's
			-- output to the capabilities of the user agent.
		do
			Result := meta_string_variable ({WGI_META_NAMES}.http_user_agent)
		end

	http_authorization: detachable READABLE_STRING_32
			-- Contents of the Authorization: header from the current request, if there is one.
		do
			Result := meta_string_variable ({WGI_META_NAMES}.http_authorization)
		end

feature -- Access: Extension to CGI meta parameters - 1.1

	request_uri: READABLE_STRING_32
			-- The URI which was given in order to access this page; for instance, '/index.html'.

	orig_path_info: detachable READABLE_STRING_32
			-- Original version of `path_info' before processed by Current environment

feature {NONE} -- Element change: CGI meta parameter related to PATH_INFO

	set_orig_path_info (s: READABLE_STRING_32)
			-- Set ORIG_PATH_INFO to `s'
		require
			s_attached: s /= Void
		do
			orig_path_info := s
			set_meta_string_variable ({WGI_META_NAMES}.orig_path_info, s)
		end

	unset_orig_path_info
			-- Unset ORIG_PATH_INFO
		do
			orig_path_info := Void
			unset_meta_variable ({WGI_META_NAMES}.orig_path_info)
		ensure
			unset: attached meta_variable ({WGI_META_NAMES}.orig_path_info)
		end

	update_path_info
			-- Fix and update PATH_INFO value if needed
		local
			l_path_info: STRING
		do
			l_path_info := path_info
			--| Warning
			--| on IIS: we might have   PATH_INFO = /sample.exe/foo/bar
			--| on apache:				PATH_INFO = /foo/bar
			--| So, we might need to check with SCRIPT_NAME and remove it on IIS
			--| store original PATH_INFO in ORIG_PATH_INFO
			if l_path_info.is_empty then
				unset_orig_path_info
			else
				set_orig_path_info (l_path_info)
				if attached script_name as l_script_name then
					if l_path_info.starts_with (l_script_name) then
						path_info := l_path_info.substring (l_script_name.count + 1 , l_path_info.count)
					end
				end
			end
		end

feature {NONE} -- Query parameters

	query_parameters_table: HASH_TABLE [WGI_VALUE, READABLE_STRING_GENERAL]
			-- Variables extracted from QUERY_STRING	
		local
			vars: like internal_query_parameters_table
			p,e: INTEGER
			rq_uri: like request_uri
			s: detachable STRING
		do
			vars := internal_query_parameters_table
			if vars = Void then
				s := query_string
				if s = Void then
					rq_uri := request_uri
					p := rq_uri.index_of ('?', 1)
					if p > 0 then
						e := rq_uri.index_of ('#', p + 1)
						if e = 0 then
							e := rq_uri.count
						else
							e := e - 1
						end
						s := rq_uri.substring (p+1, e)
					end
				end
				vars := urlencoded_parameters (s, True)
				internal_query_parameters_table := vars
			end
			Result := vars
		end

feature -- Query parameters

	query_parameters: ITERATION_CURSOR [WGI_VALUE]
		do
			Result := query_parameters_table.new_cursor
		end

	query_parameter (a_name: READABLE_STRING_GENERAL): detachable WGI_VALUE
			-- Parameter for name `n'.
		do
			Result := query_parameters_table.item (a_name)
		end

feature {NONE} -- Query parameters: implementation

	urlencoded_parameters (a_content: detachable READABLE_STRING_8; decoding: BOOLEAN): HASH_TABLE [WGI_VALUE, STRING]
			-- Import `a_content'
		local
			n, p, i, j: INTEGER
			s: STRING
			l_name,l_value: STRING_32
		do
			if a_content = Void then
				create Result.make (0)
			else
				n := a_content.count
				if n = 0 then
					create Result.make (0)
				else
					create Result.make (3)
					from
						p := 1
					until
						p = 0
					loop
						i := a_content.index_of ('&', p)
						if i = 0 then
							s := a_content.substring (p, n)
							p := 0
						else
							s := a_content.substring (p, i - 1)
							p := i + 1
						end
						if not s.is_empty then
							j := s.index_of ('=', 1)
							if j > 0 then
								l_name := s.substring (1, j - 1)
								l_value := s.substring (j + 1, s.count)
								if decoding then
									l_name := url_encoder.decoded_string (l_name)
									l_value := url_encoder.decoded_string (l_value)
								end
								Result.force (new_string_value (l_name, l_value), l_name)
							end
						end
					end
				end
			end
		end

feature {NONE} -- Form fields and related

	form_data_parameters_table: HASH_TABLE [WGI_VALUE, READABLE_STRING_GENERAL]
			-- Variables sent by POST request	
		local
			vars: like internal_form_data_parameters_table
			s: STRING
			n: NATURAL_64
			l_type: like content_type
		do
			vars := internal_form_data_parameters_table
			if vars = Void then
				n := content_length_value
				if n > 0 then
					l_type := content_type
					if
						l_type /= Void and then
						l_type.starts_with ({HTTP_CONSTANTS}.multipart_form)
					then
						create vars.make (5)
						--| FIXME: optimization ... fetch the input data progressively, otherwise we might run out of memory ...
						s := form_input_data (n.to_integer_32) --| FIXME truncated from NAT64 to INT32
						analyze_multipart_form (l_type, s, vars)
					else
						s := form_input_data (n.to_integer_32) --| FIXME truncated from NAT64 to INT32
						vars := urlencoded_parameters (s, True)
					end
					if raw_post_data_recorded then
						vars.force (new_string_value ("RAW_POST_DATA", s), "RAW_POST_DATA")
					end
				else
					create vars.make (0)
				end
				internal_form_data_parameters_table := vars
			end
			Result := vars
		end

feature -- Form fields and related	

	form_data_parameters: ITERATION_CURSOR [WGI_VALUE]
		do
			Result := form_data_parameters_table.new_cursor
		end

	form_data_parameter (a_name: READABLE_STRING_GENERAL): detachable WGI_VALUE
			-- Field for name `a_name'.
		do
			Result := form_data_parameters_table.item (a_name)
		end

	uploaded_files: HASH_TABLE [WGI_UPLOADED_FILE_DATA, STRING]
			-- Table of uploaded files information
			--| name: original path from the user
			--| type: content type
			--| tmp_name: path to temp file that resides on server
			--| tmp_base_name: basename of `tmp_name'
			--| error: if /= 0 , there was an error : TODO ...
			--| size: size of the file given by the http request

feature {NONE} -- Cookies

	cookies_table: HASH_TABLE [WGI_VALUE, READABLE_STRING_GENERAL]
			-- Expanded cookies variable
		local
			i,j,p,n: INTEGER
			l_cookies: like internal_cookies_table
			k,v,s: STRING
		do
			l_cookies := internal_cookies_table
			if l_cookies = Void then
				if attached {WGI_STRING_VALUE} meta_variable ({WGI_META_NAMES}.http_cookie) as val then
					s := val.string
					create l_cookies.make (5)
					from
						n := s.count
						p := 1
						i := 1
					until
						p < 1
					loop
						i := s.index_of ('=', p)
						if i > 0 then
							j := s.index_of (';', i)
							if j = 0 then
								j := n + 1
								k := s.substring (p, i - 1)
								v := s.substring (i + 1, n)

								p := 0 -- force termination
							else
								k := s.substring (p, i - 1)
								v := s.substring (i + 1, j - 1)
								p := j + 1
							end
							l_cookies.force (new_string_value (k, v), k)
						end
					end
				else
					create l_cookies.make (0)
				end
				internal_cookies_table := l_cookies
			end
			Result := l_cookies
		end

feature -- Cookies

	cookies: ITERATION_CURSOR [WGI_VALUE]
		do
			Result := cookies_table.new_cursor
		end

	cookie (a_name: READABLE_STRING_GENERAL): detachable WGI_VALUE
			-- Field for name `a_name'.
		do
			Result := cookies_table.item (a_name)
		end

feature {NONE} -- Access: global variable

	items_table: HASH_TABLE [WGI_VALUE, READABLE_STRING_GENERAL]
			-- Table containing all the various variables
			-- Warning: this is computed each time, if you change the content of other containers
			-- this won't update this Result's content, unless you query it again
		local
			vars: ITERATION_CURSOR [WGI_VALUE]
		do
			create Result.make (100)

			vars := meta_variables
			from
--				vars.start
			until
				vars.after
			loop
				Result.force (vars.item, vars.item.name)
				vars.forth
			end

			vars := query_parameters
			from
--				vars.start
			until
				vars.after
			loop
				Result.force (vars.item, vars.item.name)
				vars.forth
			end

			vars := form_data_parameters
			from
--				vars.start
			until
				vars.after
			loop
				Result.force (vars.item, vars.item.name)
				vars.forth
			end

			vars := cookies
			from
--				vars.start
			until
				vars.after
			loop
				Result.force (vars.item, vars.item.name)
				vars.forth
			end
		end

feature -- Access: global variable		

	items: ITERATION_CURSOR [WGI_VALUE]
		do
			Result := items_table.new_cursor
		end

	item (a_name: READABLE_STRING_GENERAL): detachable WGI_VALUE
			-- Variable named `a_name' from any of the variables container
			-- and following a specific order
			-- execution, environment, get, post, cookies
		local
			v: detachable WGI_VALUE
		do
			v := meta_variable (a_name)
			if v = Void then
				v := query_parameter (a_name)
				if v = Void then
					v := form_data_parameter (a_name)
					if v = Void then
						v := cookie (a_name)
					end
				end
			end
--			if s /= Void then
--				Result := s.as_string_32
--			end
		end

	string_item (a_name: READABLE_STRING_GENERAL): detachable READABLE_STRING_32
		do
			if attached {WGI_STRING_VALUE} item (a_name) as val then
				Result := val.string
			else
				check is_string_value: False end
			end
		end

feature -- Uploaded File Handling

	is_uploaded_file (a_filename: STRING): BOOLEAN
			-- Is `a_filename' a file uploaded via HTTP Form
		local
			l_files: like uploaded_files
		do
			l_files := uploaded_files
			if not l_files.is_empty then
				from
					l_files.start
				until
					l_files.after or Result
				loop
					if attached l_files.item_for_iteration.tmp_name as l_tmp_name and then l_tmp_name.same_string (a_filename) then
						Result := True
					end
					l_files.forth
				end
			end
		end

feature -- URL Utility

	absolute_script_url (a_path: STRING): STRING
			-- Absolute Url for the script if any, extended by `a_path'
		do
			Result := script_url (a_path)
			if attached http_host as h then
				Result.prepend (h)
			else
				--| Issue ??
			end
		end

	script_url (a_path: STRING): STRING
			-- Url relative to script name if any, extended by `a_path'
		local
			l_base_url: like internal_url_base
			i,m,n: INTEGER
			l_rq_uri: like request_uri
		do
			l_base_url := internal_url_base
			if l_base_url = Void then
				if attached script_name as l_script_name then
					l_rq_uri := request_uri
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

feature -- Element change

	set_raw_post_data_recorded (b: BOOLEAN)
			-- Set `raw_post_data_recorded' to `b'
		do
			raw_post_data_recorded := b
		end

	set_error_handler (ehdl: like error_handler)
			-- Set `error_handler' to `ehdl'
		do
			error_handler := ehdl
		end

feature {NONE} -- Temporary File handling		

	delete_uploaded_file (uf: WGI_UPLOADED_FILE_DATA)
			-- Delete file `a_filename'
		require
			uf_valid: uf /= Void
		local
			f: RAW_FILE
		do
			if uploaded_files.has_item (uf) then
				if attached uf.tmp_name as fn then
					create f.make (fn)
					if f.exists and then f.is_writable then
						f.delete
					else
						error_handler.add_custom_error (0, "Can not delete uploaded file", "Can not delete file %""+ fn +"%"")
					end
				else
					error_handler.add_custom_error (0, "Can not delete uploaded file", "Can not delete uploaded file %""+ uf.name +"%" Tmp File not found")
				end
			else
				error_handler.add_custom_error (0, "Not an uploaded file", "This file %""+ uf.name +"%" is not an uploaded file.")
			end
		end

	save_uploaded_file (a_content: STRING; a_up_fn_info: WGI_UPLOADED_FILE_DATA)
			-- Save uploaded file content to `a_filename'
		local
			bn: STRING
			l_safe_name: STRING
			f: RAW_FILE
			dn: STRING
			fn: FILE_NAME
			d: DIRECTORY
			n: INTEGER
			rescued: BOOLEAN
		do
			if not rescued then
				dn := (create {EXECUTION_ENVIRONMENT}).current_working_directory
				create d.make (dn)
				if d.exists and then d.is_writable then
					l_safe_name := safe_filename (a_up_fn_info.name)
					from
						create fn.make_from_string (dn)
						bn := "tmp-" + l_safe_name
						fn.set_file_name (bn)
						create f.make (fn.string)
						n := 0
					until
						not f.exists
						or else n > 1_000
					loop
						n := n + 1
						fn.make_from_string (dn)
						bn := "tmp-" + n.out + "-" + l_safe_name
						fn.set_file_name (bn)
						f.make (fn.string)
					end

					if not f.exists or else f.is_writable then
						a_up_fn_info.set_tmp_name (f.name)
						a_up_fn_info.set_tmp_basename (bn)
						f.open_write
						f.put_string (a_content)
						f.close
					else
						a_up_fn_info.set_error (-1)
					end
				else
					error_handler.add_custom_error (0, "Directory not writable", "Can not create file in directory %""+ dn +"%"")
				end
			else
				a_up_fn_info.set_error (-1)
			end
		rescue
			rescued := True
			retry
		end

	safe_filename (fn: STRING): STRING
		local
			c: CHARACTER
			i, n, p: INTEGER
			l_accentued, l_non_accentued: STRING
		do
			l_accentued := "ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÒÓÔÕÖÙÚÛÜÝàáâãäåçèéêëìíîïðòóôõöùúûüýÿ"
			l_non_accentued := "AAAAAACEEEEIIIIOOOOOUUUUYaaaaaaceeeeiiiioooooouuuuyy"

				--| Compute safe filename, to avoid creating impossible filename, or dangerous one
			from
				i := 1
				n := fn.count
				create Result.make (n)
			until
				i > n
			loop
				c := fn[i]
				inspect c
				when '.', '-', '_' then
					Result.extend (c)
				when 'A' .. 'Z', 'a' .. 'z', '0' .. '9' then
					Result.extend (c)
				else
					p := l_accentued.index_of (c, 1)
					if p > 0 then
						Result.extend (l_non_accentued[p])
					else
						Result.extend ('-')
					end
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation: Form analyzer

	analyze_multipart_form (t: STRING; s: STRING; vars: like form_data_parameters_table)
			-- Analyze multipart form content
			--| FIXME[2011-06-21]: integrate eMIME parser library
		require
			t_attached: t /= Void
			s_attached: s /= Void
			vars_attached: vars /= Void
		local
			p,i,next_b: INTEGER
			l_boundary_prefix: STRING
			l_boundary: STRING
			l_boundary_len: INTEGER
			m: STRING
			is_crlf: BOOLEAN
		do
			p := t.substring_index ("boundary=", 1)
			if p > 0 then
				l_boundary := t.substring (p + 9, t.count)
				p := s.substring_index (l_boundary, 1)
				if p > 1 then
					l_boundary_prefix := s.substring (1, p - 1)
					l_boundary := l_boundary_prefix + l_boundary
				else
					create l_boundary_prefix.make_empty
				end
				l_boundary_len := l_boundary.count
					--| Let's support either %R%N and %N ... 
					--| Since both cases might occurs (for instance, our implementation of CGI does not have %R%N)
					--| then let's be as flexible as possible on this.
				is_crlf := s[l_boundary_len + 1] = '%R'
				from
					i := 1 + l_boundary_len + 1
					if is_crlf then
						i := i + 1 --| +1 = CR = %R
					end
					next_b := i
				until
					i = 0
				loop
					next_b := s.substring_index (l_boundary, i)
					if next_b > 0 then
						if is_crlf then
							m := s.substring (i, next_b - 1 - 2) --| 2 = CR LF = %R %N							
						else
							m := s.substring (i, next_b - 1 - 1) --| 1 = LF = %N														
						end
						analyze_multipart_form_input (m, vars)
						i := next_b + l_boundary_len + 1
						if is_crlf then
							i := i + 1 --| +1 = CR = %R
						end
					else
						if is_crlf then
							i := i + 1
						end
						m := s.substring (i - 1, s.count)
						m.right_adjust
						if not l_boundary_prefix.same_string (m) then
							error_handler.add_custom_error (0, "Invalid form data", "Invalid ending for form data from input")
						end
						i := next_b
					end
				end
			end
		end

	analyze_multipart_form_input (s: STRING; vars_post: like form_data_parameters_table)
			-- Analyze multipart entry
		require
			s_not_empty: s /= Void and then not s.is_empty
		local
			n, i,p, b,e: INTEGER
			l_name, l_filename, l_content_type: detachable STRING
			l_header: detachable STRING
			l_content: detachable STRING
			l_line: detachable STRING
			l_up_file_info: WGI_UPLOADED_FILE_DATA
		do
			from
				p := 1
				n := s.count
			until
				p > n or l_header /= Void
			loop
				inspect s[p]
				when '%R' then -- CR
					if
						n >= p + 3 and then
						s[p+1] = '%N' and then -- LF
						s[p+2] = '%R' and then -- CR
						s[p+3] = '%N'		   -- LF
					then
						l_header := s.substring (1, p + 1)
						l_content := s.substring (p + 4, n)
					end
				when '%N' then
					if
						n >= p + 1 and then
						s[p+1] = '%N'
					then
						l_header := s.substring (1, p)
						l_content := s.substring (p + 2, n)
					end
				else
				end
				p := p + 1
			end
			if l_header /= Void and l_content /= Void then
				from
					i := 1
					n := l_header.count
				until
					i = 0 or i > n
				loop
					l_line := Void
					b := i
					p := l_header.index_of ('%N', b)
					if p > 0 then
						if l_header[p - 1] = '%R' then
							p := p - 1
							i := p + 2
						else
							i := p + 1
						end
					end
					if p > 0 then
						l_line := l_header.substring (b, p - 1)
						if l_line.starts_with ("Content-Disposition: form-data") then
							p := l_line.substring_index ("name=", 1)
							if p > 0 then
								p := p + 4 --| 4 = ("name=").count - 1
								if l_line.valid_index (p+1) and then l_line[p+1] = '%"' then
									p := p + 1
									e := l_line.index_of ('"', p + 1)
								else
									e := l_line.index_of (';', p + 1)
									if e = 0 then
										e := l_line.count
									end
								end
								l_name := l_header.substring (p + 1, e - 1)
							end

							p := l_line.substring_index ("filename=", 1)
							if p > 0 then
								p := p + 8 --| 8 = ("filename=").count - 1
								if l_line.valid_index (p+1) and then l_line[p+1] = '%"' then
									p := p + 1
									e := l_line.index_of ('"', p + 1)
								else
									e := l_line.index_of (';', p + 1)
									if e = 0 then
										e := l_line.count
									end
								end
								l_filename := l_header.substring (p + 1, e - 1)
							end
						elseif l_line.starts_with ("Content-Type: ") then
							l_content_type := l_line.substring (15, l_line.count)
						end
					else
						i := 0
					end
				end
				if l_name /= Void then
					if l_filename /= Void then
						if l_content_type = Void then
							l_content_type := default_content_type
						end
						create l_up_file_info.make (l_filename, l_content_type, l_content.count)
						save_uploaded_file (l_content, l_up_file_info)
						uploaded_files.force (l_up_file_info, l_name)
					else
						vars_post.force (new_string_value (l_name, l_content), l_name)
					end
				else
					error_handler.add_custom_error (0, "unamed multipart entry", Void)
				end
			else
				error_handler.add_custom_error (0, "missformed multipart entry", Void)
			end
		end

feature {NONE} -- Internal value

	default_content_type: STRING = "text/plain"
			-- Default content type

	form_input_data (nb: INTEGER): STRING
			-- data from input form
		local
			n: INTEGER
			t: STRING
		do
			from
				n := nb
				create Result.make (n)
				if n > 1_024 then
					n := 1_024
				end
			until
				n <= 0
			loop
				read_input (n)
				t := last_input_string
				Result.append_string (t)
				if t.count < n then
					n := 0
				end
				n := nb - t.count
			end
		end

	internal_query_parameters_table: detachable like query_parameters_table
			-- cached value for `query_parameters'

	internal_form_data_parameters_table: detachable like form_data_parameters_table
			-- cached value for `form_fields'

	internal_cookies_table: detachable like cookies_table
			-- cached value for `cookies'

feature {NONE} -- I/O: implementation

	read_input (nb: INTEGER)
			-- Read `nb' bytes from `input'
		do
			input.read_stream (nb)
		end

	last_input_string: STRING
			-- Last string read from `input'
		do
			Result := input.last_string
		end

feature {NONE} -- Implementation

	report_bad_request_error (a_message: detachable STRING)
			-- Report error
		local
			e: EWF_ERROR
		do
			create e.make ({HTTP_STATUS_CODE}.bad_request)
			if a_message /= Void then
				e.set_message (a_message)
			end
			error_handler.add_error (e)
		end

	extract_variables
			-- Extract relevant meta parameters
		local
			s: detachable READABLE_STRING_32
		do
			s := request_uri
			if s.is_empty then
				report_bad_request_error ("Missing URI")
			end
			if not has_error then
				s := request_method
				if s.is_empty then
					report_bad_request_error ("Missing request method")
				end
			end
			if not has_error then
				s := http_host
				if s = Void or else s.is_empty then
					report_bad_request_error ("Missing host header")
				end
			end
			if not has_error then
				update_path_info
			end
		end

feature {NONE} -- Implementation: utilities	

	new_string_value (a_name: READABLE_STRING_GENERAL; a_value: READABLE_STRING_32): WGI_STRING_VALUE
		do
			create Result.make (a_name, a_value)
		end

	empty_string: READABLE_STRING_32
			-- Reusable empty string

	url_encoder: URL_ENCODER
		once
			create Result
		end

	date_time_utilities: HTTP_DATE_TIME_UTILITIES
			-- Utilities classes related to date and time.
		once
			create Result
		end

invariant
	empty_string_unchanged: empty_string.is_empty

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
