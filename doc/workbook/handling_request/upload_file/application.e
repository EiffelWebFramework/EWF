note
	description : "Basic Service that show how to Upload a file"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	WSF_DEFAULT_SERVICE
		redefine
			initialize
		end

create
	make_and_launch

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			set_service_option ("port", 9090)
		end

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the incomming request
		local
			file: WSF_FILE_RESPONSE
			l_answer: STRING
		do
			if req.is_get_request_method then
				if  req.path_info.same_string ("/") then
					create file.make_html ("upload.html")
					res.send (file)
				else
					-- Here we should handle unexpected errors.
				end
			elseif req.is_post_request_method then
				if  req.path_info.same_string ("/upload") then
						-- Check if we have an uploaded file
					if req.has_uploaded_file then
							-- iterate over all the uploaded files
						create l_answer.make_from_string ("<h1>Uploaded File/s</h1><br>")
						across  req.uploaded_files as ic loop
							l_answer.append ("<strong>FileName:</strong>")
							l_answer.append (ic.item.filename)
							l_answer.append ("<br><strong>Size:</strong>")
							l_answer.append (ic.item.size.out)
							l_answer.append ("<br>")
						end
						res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-type","text/html"],["Content-lenght", l_answer.count.out]>>)
						res.put_string (l_answer)
					else
							-- Here we should handle unexpected errors.
						create l_answer.make_from_string ("<strong>No uploaded files</strong><br>")
						create l_answer.append ("Back to <a href='/'>Home</a>")
						res.put_header ({HTTP_STATUS_CODE}.bad_request, <<["Content-type","text/html"],["Content-lenght", l_answer.count.out]>>)
						res.put_string (l_answer)
					end
				else
					-- Handle error
				end
			end
		end

end
