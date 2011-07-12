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

class
	GW_REQUEST_CONTEXT_IMP

inherit
	GW_REQUEST_CONTEXT

create
	make

feature {NONE} -- Initialization

	make (env: GW_ENVIRONMENT; a_input: like input; a_output: like output)
		require
			env_attached: env /= Void
		do
			create error_handler.make
			input := a_input
			output := a_output
			environment := env
			content_length := env.content_length_value
			create execution_variables.make (10)
			create uploaded_files.make (0)

			raw_post_data_recorded := True

			initialize
			analyze
		end

	initialize
			-- Specific initialization
		local
			p: INTEGER
			dt: DATE_TIME
			env: like environment
		do
			env := environment
				--| Here one can set its own environment entries if needed

				--| do not use `force', to avoid overwriting existing variable
			if attached env.request_uri as rq_uri then
				p := rq_uri.index_of ('?', 1)
				if p > 0 then
					env.set_variable (rq_uri.substring (1, p-1), {GW_ENVIRONMENT_NAMES}.self)
				else
					env.set_variable (rq_uri, {GW_ENVIRONMENT_NAMES}.self)
				end
			end
			if env.variable ({GW_ENVIRONMENT_NAMES}.request_time) = Void then
				env.set_variable (date_time_utilities.unix_time_stamp (Void).out, {GW_ENVIRONMENT_NAMES}.request_time)
			end
		end

	analyze
			-- Analyze context, set various attributes and validate values
		do
			extract_variables
		end

feature -- Access: Input/Output

	output: GW_OUTPUT_STREAM
			-- Server output channel

	input: GW_INPUT_STREAM
			-- Server input channel

feature -- Status

	raw_post_data_recorded: BOOLEAN assign set_raw_post_data_recorded
			-- Record RAW POST DATA in environment variables
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

feature -- Access: environment variables		

	environment: GW_ENVIRONMENT
			-- Environment variables

	content_length: INTEGER
			-- Extracted Content-Length value

feature -- Access: execution variables		

	execution_variables: GW_EXECUTION_VARIABLES
			-- Execution variables set by the application

feature -- URL parameters

	parameters: GW_REQUEST_VARIABLES
		local
			vars: like internal_parameters
			p,e: INTEGER
			rq_uri: like environment.request_uri
			s: detachable STRING
		do
			vars := internal_parameters
			if vars = Void then
				s := environment.query_string
				if s = Void then
					rq_uri := environment.request_uri
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
				if s /= Void and then not s.is_empty then
					create vars.make_from_urlencoded (s, True)
				else
					create vars.make (0)
				end
				internal_parameters := vars
			end
			Result := vars
		end

feature -- Form fields and related

	form_fields: GW_REQUEST_VARIABLES
		local
			vars: like internal_form_fields
			s: STRING
			n: INTEGER
			l_type: detachable STRING
		do
			vars := internal_form_fields
			if vars = Void then
				n := content_length
				if n > 0 then
					l_type := environment.content_type
					if
						l_type /= Void and then
						l_type.starts_with ({HTTP_CONSTANTS}.multipart_form)
					then
						create vars.make (5)
						--| FIXME: optimization ... fetch the input data progressively, otherwise we might run out of memory ...
						s := form_input_data (n)
						analyze_multipart_form (l_type, s, vars)
					else
						s := form_input_data (n)
						create vars.make_from_urlencoded (s, True)
					end
					if raw_post_data_recorded then
						vars.add_variable (s, "RAW_POST_DATA")
					end
				else
					create vars.make (0)
				end
				internal_form_fields := vars
			end
			Result := vars
		end

	uploaded_files: HASH_TABLE [TUPLE [name: STRING; type: STRING; tmp_name: STRING; tmp_basename: STRING; error: INTEGER; size: INTEGER], STRING]
			-- Table of uploaded files information
			--| name: original path from the user
			--| type: content type
			--| tmp_name: path to temp file that resides on server
			--| tmp_base_name: basename of `tmp_name'
			--| error: if /= 0 , there was an error : TODO ...
			--| size: size of the file given by the http request

feature -- Cookies

	cookies_variables: HASH_TABLE [STRING, STRING]
			-- Expanded cookies variable
		local
			l_cookies: like cookies
		do
			l_cookies := cookies
			create Result.make (l_cookies.count)
			from
				l_cookies.start
			until
				l_cookies.after
			loop
				if attached l_cookies.item_for_iteration.variables as vars then
					from
						vars.start
					until
						vars.after
					loop
						Result.force (vars.item_for_iteration, vars.key_for_iteration)
						vars.forth
					end
				else
					check same_name: l_cookies.key_for_iteration.same_string (l_cookies.item_for_iteration.name) end
					Result.force (l_cookies.item_for_iteration.value, l_cookies.key_for_iteration)
				end
				l_cookies.forth
			end
		end

	cookies: HASH_TABLE [GW_COOKIE, STRING]
			-- Cookies Information
		local
			i,j,p,n: INTEGER
			l_cookies: like internal_cookies
			k,v: STRING
		do
			l_cookies := internal_cookies
			if l_cookies = Void then
				if attached environment_variable ({GW_ENVIRONMENT_NAMES}.http_cookie) as s then
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
							l_cookies.put (create {GW_COOKIE}.make (k,v), k)
						end
					end
				else
					create l_cookies.make (0)
				end
				internal_cookies := l_cookies
			end
			Result := l_cookies
		end

feature -- Query

--	script_absolute_url (a_path: STRING): STRING
--			-- Absolute Url for the script if any, extended by `a_path'
--		do
--			Result := script_url (a_path)
--			if attached http_host as h then
--				Result.prepend (h)
--			else
--				--| Issue ??
--			end
--		end

--	script_url (a_path: STRING): STRING
--			-- Url relative to script name if any, extended by `a_path'
--		require
--			a_path_attached: a_path /= Void
--		local
--			l_base_url: like script_url_base
--			i,m,n: INTEGER
--			l_rq_uri: like request_uri
--		do
--			l_base_url := script_url_base
--			if l_base_url = Void then
--				if attached environment.script_name as l_script_name then
--					l_rq_uri := request_uri
--					if l_rq_uri.starts_with (l_script_name) then
--						l_base_url := l_script_name
--					else
--						--| Handle Rewrite url engine, to have clean path
--						from
--							i := 1
--							m := l_rq_uri.count
--							n := l_script_name.count
--						until
--							i > m or i > n or l_rq_uri[i] /= l_script_name[i]
--						loop
--							i := i + 1
--						end
--						if i > 1 then
--							if l_rq_uri[i-1] = '/' then
--								i := i -1
--							end
--							l_base_url := l_rq_uri.substring (1, i - 1)
--						end
--					end
--				end
--				if l_base_url = Void then
--					create l_base_url.make_empty
--				end
--				script_url_base := l_base_url
--			end
--			Result := l_base_url + a_path
--		end

--	script_url_base: detachable STRING
--			-- URL base of potential script

feature -- Access environment information

	request_time: detachable DATE_TIME
			-- Request time (UTC)
		do
			if
				attached environment.variable ({GW_ENVIRONMENT_NAMES}.request_time) as t and then
				t.is_integer_64
			then
				Result := date_time_utilities.unix_time_stamp_to_date_time (t.to_integer_64)
			end
		end

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

	update_path_info (env: GW_ENVIRONMENT)
			-- Fix and update PATH_INFO value if needed
		local
			l_path_info: STRING
		do
			l_path_info := env.path_info
			--| Warning
			--| on IIS: we might have   PATH_INFO = /sample.exe/foo/bar
			--| on apache:				PATH_INFO = /foo/bar
			--| So, we might need to check with SCRIPT_NAME and remove it on IIS
			--| store original PATH_INFO in ORIG_PATH_INFO
			if l_path_info.is_empty then
				env.unset_orig_path_info
			else
				env.set_orig_path_info (l_path_info)
				if attached env.script_name as l_script_name then
					if l_path_info.starts_with (l_script_name) then
						env.path_info := l_path_info.substring (l_script_name.count + 1 , l_path_info.count)
					end
				end
			end
		end

feature -- Uploaded File Handling

	move_uploaded_file (a_filename: STRING; a_destination: STRING): BOOLEAN
			-- Move uploaded file `a_filename' to `a_destination'
			--| if this is not an uploaded file, do not move it.
		local
			f: RAW_FILE
		do
			if is_uploaded_file (a_filename) then
				create f.make (a_filename)
				if f.exists then
					f.change_name (a_destination)
					Result := True
				end
			end
		end

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
					if l_files.item_for_iteration.tmp_name.same_string (a_filename) then
						Result := True
					end
					l_files.forth
				end
			end
		end

feature {NONE} -- Temporary File handling		

	delete_uploaded_file (a_filename: STRING)
			-- Delete file `a_filename'
		local
			f: RAW_FILE
		do
			if is_uploaded_file (a_filename) then
				create f.make (a_filename)
				if f.exists and then f.is_writable then
					f.delete
				else
					error_handler.add_custom_error (0, "Can not delete file", "Can not delete file %""+ a_filename +"%"")
				end
			else
				error_handler.add_custom_error (0, "Not uploaded file", "This file %""+ a_filename +"%" is not an uploaded file.")
			end
		end

	save_uploaded_file (a_content: STRING; a_filename: STRING): detachable TUPLE [name: STRING; basename: STRING]
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
					l_safe_name := safe_filename (a_filename)
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
						f.open_write
						f.put_string (a_content)
						f.close
						Result := [f.name, bn]
					else
						Result := Void
					end
				else
					error_handler.add_custom_error (0, "Directory not writable", "Can not create file in directory %""+ dn +"%"")
				end
			else
				Result := Void
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

	analyze_multipart_form (t: STRING; s: STRING; vars: like form_fields)
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

	analyze_multipart_form_input (s: STRING; vars_post: like form_fields)
			-- Analyze multipart entry
		require
			s_not_empty: s /= Void and then not s.is_empty
		local
			n, i,p, b,e: INTEGER
			l_name, l_filename, l_content_type: detachable STRING
			l_header: detachable STRING
			l_content: detachable STRING
			l_line: detachable STRING
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
						if attached save_uploaded_file (l_content, l_filename) as l_saved_fn_info then
							uploaded_files.force ([l_filename, l_content_type, l_saved_fn_info.name, l_saved_fn_info.basename, 0, l_content.count], l_name)
						else
							uploaded_files.force ([l_filename, l_content_type, "", "", -1, l_content.count], l_name)
						end
					else
						vars_post.add_variable (l_content, l_name)
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

	internal_parameters: detachable like parameters
			-- cached value for `parameters'

	internal_form_fields: detachable like form_fields
			-- cached value for `form_fields'

	internal_cookies: detachable like cookies
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
			e: GW_ERROR
		do
			create e.make ({HTTP_STATUS_CODE}.bad_request)
			if a_message /= Void then
				e.set_message (a_message)
			end
			error_handler.add_error (e)
		end

	extract_variables
			-- Extract relevant environment variables
		local
			s: detachable STRING
		do
			s := environment.request_uri
			if s.is_empty then
				report_bad_request_error ("Missing URI")
			end
			if not has_error then
				s := environment.request_method
				if s.is_empty then
					report_bad_request_error ("Missing request method")
				end
			end
			if not has_error then
				s := environment.http_host
				if s = Void or else s.is_empty then
					report_bad_request_error ("Missing host header")
				end
			end
			if not has_error then
				update_path_info (environment)
			end
		end

feature {NONE} -- Implementation: utilities		

	date_time_utilities: HTTP_DATE_TIME_UTILITIES
			-- Utilities classes related to date and time.
		once
			create Result
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
