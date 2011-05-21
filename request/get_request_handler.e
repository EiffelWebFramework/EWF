class
	GET_REQUEST_HANDLER

inherit
	SHARED_DOCUMENT_ROOT

	SHARED_URI_CONTENTS_TYPES

	HTTP_REQUEST_HANDLER

	HTTP_CONSTANTS

create
	default_create

feature

	process
			-- process the request and create an answer
		local
			fname: STRING_8
			f: RAW_FILE
			ctype, extension: STRING_8
		do
			create answer.make
			if request_uri.is_equal ("/") then
				process_default
				answer.set_content_type ("text/html")
			else
				fname := Document_root_cell.item.twin
				fname.append (request_uri)
				debug
					print ("URI name: " + fname)
				end
				create f.make (fname)
				create answer.make
				if f.exists then
					extension := Ct_table.extension (request_uri)
					ctype := Ct_table.content_types.item (extension)
					if f.is_directory then
						process_directory (f)
					else
						if ctype = Void then
							process_raw_file (f)
							answer.set_content_type ("text/html")
						else
							if ctype.is_equal ("text/html") then
								process_text_file (f)
							else
								process_raw_file (f)
							end
							answer.set_content_type (ctype)
						end
					end
				else
					answer.set_status_code (Not_found)
					answer.set_reason_phrase (Not_found_message)
					answer.set_reply_text ("Not found on this server")
				end
			end
			answer.set_content_length (answer.reply_text.count.out)
		end

	process_default
			-- Return a defaul response
		local
			html: STRING_8
		do
			answer.set_reply_text ("")
			html := " <html> <head> <title> NINO HTTPD </title> " + "    </head>   " + "       <body>    " + " <h1> Welcome to NINO HTTPD! </h1> " + " <p>  Default page  " + " </p> " + " </body> " + " </html> "
			answer.append_reply_text (html)
		end

	process_text_file (f: FILE)
			-- send a text file reply
		require
			valid_f: f /= Void
		do
			f.open_read
			from
				answer.set_reply_text ("")
				f.read_line
			until
				f.end_of_file
			loop
				answer.append_reply_text (f.last_string)
				answer.append_reply_text (Crlf)
				f.read_line
			end
			f.close
		end

	process_raw_file (f: FILE)
			-- send a raw file reply
		require
			valid_f: f /= Void
		do
			f.open_read
			from
				answer.set_reply_text ("")
			until
				f.end_of_file
			loop
				f.read_stream_thread_aware (1024)
				answer.append_reply_text (f.last_string)
			end
			f.close
		end

	process_directory (f: FILE)
			--read the directory
		require
			is_directory: f.is_directory
		local
			l_dir: DIRECTORY
			files: ARRAYED_LIST [STRING_8]
			html1: STRING_8
			html2: STRING_8
			htmldir: STRING_8
			path: STRING_8
			index: INTEGER_32
		do
			answer.set_reply_text ("")
			html1 := " <html> <head> <title> NINO HTTPD </title> " + "    </head>   " + "       <body>    " + " <h1> Welcome to NINO HTTPD! </h1> " + " <p>  Default page  "
			html2 := " </p> " + " </body> " + " </html> "
			path := f.name.twin
			index := path.last_index_of ('/', path.count)
			path.remove_substring (1, index)
			create l_dir.make_open_read (f.name)
			files := l_dir.linear_representation
			from
				files.start
				htmldir := "<ul>"
			until
				files.after
			loop
				htmldir := htmldir + "<li><a href=%"./" + path + "/" + files.item_for_iteration + "%">" + files.item_for_iteration + "</a> </li>%N"
				files.forth
			end
			htmldir := htmldir + "</ul>"
			answer.append_reply_text (html1 + htmldir + html2)
		end

end -- class GET_REQUEST_HANDLER

