note
	description : "Reading Parameters from a HTML FORM  (method POST) "
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
			l_parameter_names: STRING
			l_answer: STRING
			idioms: LIST[STRING]
			l_raw_data: STRING
		do
			if req.is_get_request_method then
				create file.make_html ("form.html")
				res.send (file)
			elseif req.is_post_request_method then
				 req.set_raw_input_data_recorded (True)

					-- (3) Read Raw Data
				 create l_raw_data.make_empty
				 req.read_input_data_into (l_raw_data)

					-- (1) the parameter is case sensitive
				if not (attached req.form_parameter ("GIVEN-NAME")) then
					-- Wrong `GIVEN-NAME' need to be in lower case.
				end

					-- (2) Multiple values
				if attached {WSF_MULTIPLE_STRING} req.form_parameter ("languages") as l_languages then
						-- Get all the associated values
					create {ARRAYED_LIST[STRING]} idioms.make (2)
					across l_languages as ic loop idioms.force (ic.item.value) end
				elseif attached {WSF_STRING} req.form_parameter ("langauges") as l_language then
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

				across req.form_parameters as ic loop
					 l_parameter_names.append (ic.item.key)
					 l_parameter_names.append ("<br>")

					 l_answer.append (ic.item.key)
					 l_answer.append_character ('=')
					 if attached {WSF_STRING} req.form_parameter (ic.item.key) as l_value then
					 	l_answer.append_string (l_value.value)
					 end
					 l_answer.append ("<br>")
				end

				l_parameter_names.append ("<br>")
				l_parameter_names.append_string (l_answer)
				l_parameter_names.append ("<br>")
				l_parameter_names.append ("<h2>Raw content</h2>")
				l_parameter_names.append (l_raw_data)
				res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", l_parameter_names.count.out]>>)
				res.put_string (l_parameter_names)
			else
				-- Here we should handle unexpected errors.
			end
		end

end
