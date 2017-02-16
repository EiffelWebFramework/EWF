note
	description : "Basic Service that show how to handle a GET request"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION_EXECUTION

inherit
	WSF_EXECUTION

create
	make

feature -- Basic operations

	execute
			-- Execute the incomming request
		local
			file: WSF_FILE_RESPONSE
			l_parameter_names: STRING
			l_answer: STRING
			idioms: LIST[STRING]
			l_raw_data: STRING
		do
			if request.is_get_request_method then
				if  request.path_info.same_string ("/") then
					create file.make_html ("form.html")
					response.send (file)
				elseif request.path_info.same_string ("/search") then

						-- (1) the parameter is case sensitive
					if not (attached request.query_parameter ("GIVEN-NAME")) then
						-- Wrong `GIVEN-NAME' need to be in lower case.
					end

						-- (2) Multiple values
					if attached {WSF_MULTIPLE_STRING} request.query_parameter ("languages") as l_languages then
							-- Get all the associated values
						create {ARRAYED_LIST[STRING]} idioms.make (2)
						across l_languages as ic loop idioms.force (ic.item.value) end
					elseif attached {WSF_STRING} request.query_parameter ("languages") as l_language then
						-- Single value
						print (l_language.value)
					else
						-- Value Missing	
					end

						-- Read the all parameters names and his values.
					create l_parameter_names.make_from_string ("<h2>Parameters Names</h2>")
					l_parameter_names.append ("<br>")
					create l_answer.make_from_string ("<h2>Parameter Names and Values</h2>")
					l_answer.append ("<br>")
					across request.query_parameters as ic loop
						 l_parameter_names.append (ic.item.key)
						 l_parameter_names.append ("<br>")

						 l_answer.append (ic.item.key)
						 l_answer.append_character ('=')
						 if attached {WSF_STRING} request.query_parameter (ic.item.key) as l_value then
						 	l_answer.append_string (l_value.value)
						 end
						 l_answer.append ("<br>")
					end

					l_parameter_names.append ("<br>")
					l_parameter_names.append_string (l_answer)
					response.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", l_parameter_names.count.out]>>)
					response.put_string (l_parameter_names)
				elseif request.path_info.same_string ("/link") then
						-- WSF_TABLE example
						create l_parameter_names.make_from_string ("<h2>Parameters Name</h2>")
					if attached {WSF_TABLE} request.query_parameter ("tab") as l_tab then
						l_parameter_names.append ("<br>")
						l_parameter_names.append (l_tab.name)

						from
							l_tab.values.start
						until
							l_tab.values.after
						loop
							l_parameter_names.append ("<br>")
							l_parameter_names.append (l_tab.values.key_for_iteration)
							if attached {WSF_STRING} l_tab.value (l_tab.values.key_for_iteration) as l_value then
								l_parameter_names.append ("=")
								l_parameter_names.append (l_value.value)
							end
							l_tab.values.forth
						end
						l_parameter_names.append ("<br>")
						response.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", l_parameter_names.count.out]>>)
						response.put_string (l_parameter_names)

					end
				else
					-- Here we should handle unexpected errors.
				end
			end
		end

end
