note
	description: "[
			Request handler used to respond file system request.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	REQUEST_FILE_SYSTEM_HANDLER [C -> REQUEST_HANDLER_CONTEXT]

inherit
	REQUEST_HANDLER [C]

create
	make

feature {NONE} -- Initialization

	make (a_root: READABLE_STRING_8)
		require
			a_root_exists: node_exists (a_root)
		do
			document_root := a_root
		end

feature -- Access

	document_root: READABLE_STRING_8
			-- Document root for the file system

	directory_index: detachable ARRAY [READABLE_STRING_8]
			-- File serve if a directory index is requested

feature -- Element change

	set_directory_index (idx: like directory_index)
			-- Set `directory_index' as `idx'
		do
			if idx = Void or else idx.is_empty then
				directory_index := Void
			else
				directory_index := idx
			end
		end

feature -- Execution

	execute (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler	
		local
			h: HTTP_HEADER
			s: STRING
			uri: STRING
		do
			if attached {WSF_STRING} ctx.path_parameter ("path") as l_path then
				uri := l_path.string
				process_uri (uri, ctx, req, res)
			else
				create h.make
				h.put_content_type_text_html
				s := "Hello " + ctx.path + "%N"
				s.append ("root=" + document_root)

				h.put_content_length (s.count)
				res.set_status_code ({HTTP_STATUS_CODE}.ok)
				res.put_header_text (h.string)
				res.put_string (s)
			end
		end

	process_uri (uri: READABLE_STRING_8; ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			f: RAW_FILE
			fn: READABLE_STRING_8
		do
			fn := resource_filename (uri)
			create f.make (fn)
			if f.exists then
				if f.is_readable then
					if f.is_directory then
						respond_index (req.request_uri, fn, ctx, req, res)
					else
						respond_file (f, ctx, req, res)
					end
				else
					respond_access_denied (uri, ctx, req, res)
				end
			else
				respond_not_found (uri, ctx, req, res)
			end
		end

	respond_index (a_uri: READABLE_STRING_8; dn: READABLE_STRING_8; ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			h: HTTP_HEADER
			uri, s: STRING_8
			d: DIRECTORY
			l_files: LIST [STRING_8]
		do
			create d.make_open_read (dn)
			if attached directory_index_file (d) as f then
				respond_file (f, ctx, req, res)
			else
				uri := a_uri
				if not uri.is_empty and then uri [uri.count] /= '/'  then
					uri.append_character ('/')
				end
				s := "[
					<html>
						<head>
							<title>Index for folder: $URI</title>
						</head>
						<body>
							<h1>Index for $URI</h1>
							<ul>
					]"
				s.replace_substring_all ("$URI", uri)

				from
					l_files := d.linear_representation
					l_files.start
				until
					l_files.after
				loop
					s.append ("<li><a href=%"" + uri + l_files.item_for_iteration + "%">" + l_files.item_for_iteration + "</a></li>%N")
					l_files.forth
				end
				s.append ("[
							</ul>
						</body>
					</html>
					]"
				)

				create h.make
				h.put_content_type_text_html
				res.set_status_code ({HTTP_STATUS_CODE}.ok)
				h.put_content_length (s.count)
				res.put_header_text (h.string)
				if not req.request_method.same_string ({HTTP_REQUEST_METHODS}.method_head) then
					res.put_string (s)
				end
				res.flush
			end
			d.close
		end

	respond_file (f: FILE; ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			ext: READABLE_STRING_8
			ct: detachable READABLE_STRING_8
			fres: WSF_FILE_RESPONSE
		do
			ext := extension (f.name)
			ct := extension_mime_mapping.mime_type (ext)
			if ct = Void then
				ct := {HTTP_MIME_TYPES}.application_force_download
			end
			create fres.make_with_content_type (ct, f.name)
			fres.set_status_code ({HTTP_STATUS_CODE}.ok)
			fres.set_answer_head_request_method (req.request_method.same_string ({HTTP_REQUEST_METHODS}.method_head))

			res.put_response (fres)
		end

	respond_not_found (uri: READABLE_STRING_8; ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			h: HTTP_HEADER
			s: STRING_8
		do
			create h.make
			h.put_content_type_text_plain
			create s.make_empty
			s.append ("Resource %"" + uri + "%" not found%N")
			res.set_status_code ({HTTP_STATUS_CODE}.not_found)
			h.put_content_length (s.count)
			res.put_header_text (h.string)
			res.put_string (s)
			res.flush
		end

	respond_access_denied (uri: READABLE_STRING_8; ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			h: HTTP_HEADER
			s: STRING_8
		do
			create h.make
			h.put_content_type_text_plain
			create s.make_empty
			s.append ("Resource %"" + uri + "%": Access denied%N")
			res.set_status_code ({HTTP_STATUS_CODE}.forbidden)
			h.put_content_length (s.count)
			res.put_header_text (h.string)
			res.put_string (s)
			res.flush
		end

feature {NONE} -- Implementation

	directory_index_file (d: DIRECTORY): detachable FILE
		local
			f: detachable RAW_FILE
			fn: FILE_NAME
		do
			if attached directory_index as default_index then
				across
					default_index as c
				until
					Result /= Void
				loop
					if d.has_entry (c.item) then
						create fn.make_from_string (d.name)
						fn.set_file_name (c.item)
						if f = Void then
							create f.make (fn.string)
						else
							f.make (fn.string)
						end
						if f.exists and then f.is_readable then
							Result := f
						end
					end
				end
			end
		end

	resource_filename (uri: READABLE_STRING_8): READABLE_STRING_8
		do
			Result := real_filename (document_root + real_filename (uri))
		end

	dirname (uri: READABLE_STRING_8): READABLE_STRING_8
		local
			p: INTEGER
		do
			p := uri.last_index_of ('/', uri.count)
			if p > 0 then
				Result := uri.substring (1, p - 1)
			else
				create {STRING_8} Result.make_empty
			end
		end

	filename (uri: READABLE_STRING_8): READABLE_STRING_8
		local
			p: INTEGER
		do
			p := uri.last_index_of ('/', uri.count)
			if p > 0 then
				Result := uri.substring (p + 1, uri.count)
			else
				Result := uri.twin
			end
		end

	extension (uri: READABLE_STRING_8): READABLE_STRING_8
		local
			p: INTEGER
		do
			p := uri.last_index_of ('.', uri.count)
			if p > 0 then
				Result := uri.substring (p + 1, uri.count)
			else
				create {STRING_8} Result.make_empty
			end
		end

	real_filename (fn: STRING): STRING
			-- Real filename from url-path `fn'
			--| Find a better design for this piece of code
			--| Eventually in a spec/$ISE_PLATFORM/ specific cluster
		do
			if fn.is_empty then
				Result := fn
			else
				if {PLATFORM}.is_windows then
					create Result.make_from_string (fn)
					Result.replace_substring_all ("/", "\")
					if Result [Result.count] = '\' then
						Result.remove_tail (1)
					end
				else
					Result := fn
					if Result [Result.count] = '/' then
						Result.remove_tail (1)
					end
				end
			end
		end

feature {NONE} -- Implementation

	node_exists (p: READABLE_STRING_8): BOOLEAN
		local
			f: RAW_FILE
		do
			create f.make (p)
			Result := f.exists
		end

	extension_mime_mapping: HTTP_FILE_EXTENSION_MIME_MAPPING
		local
			f: RAW_FILE
		once
			create f.make ("mime.types")
			if f.exists and then f.is_readable then
				create Result.make_from_file (f.name)
			else
				create Result.make_default
			end
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
