note
	description: "Summary description for {WSF_PAGE_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_PAGE_CONTROL

feature {NONE} -- Initialization

	make (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			request := req
			response := res
			initialize_controls
		end

feature -- Access

	request: WSF_REQUEST

	response: WSF_RESPONSE

feature

	initialize_controls
		deferred
		ensure
			attached control
		end

	process
		deferred
		end

feature

	execute
		local
			event: detachable STRING
			control_name: detachable STRING
			states: JSON_OBJECT
		do
			control_name := get_parameter ("control_name")
			event := get_parameter ("event")
			if attached event and attached control_name and attached control then
				control.handle_callback (control_name, event, Current)
				create states.make
				control.read_state (states)
				response.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "application/json"]>>)
				response.put_string (states.representation)
			else
				process
				render
			end
		end

	render
		local
			data: STRING
			page: WSF_PAGE_RESPONSE
			states: JSON_OBJECT
		do
			create states.make
			control.read_state (states)

			data := "<html><head>"
			data.append ("</head><body>")
			data.append (control.render)
			data.append ("<script type=%"text/javascript%">var states=")
			data.append (states.representation)
			data.append (";</script>")
			data.append ("<script src=%"//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js%"></script>")
			data.append ("<script src=%"/widget.js%"></script>")
			data.append ("</body></html>")
			create page.make
			page.put_header ({HTTP_STATUS_CODE}.ok,  <<["Content-Type", "text/html"]>>)
			page.set_body (data)
			response.send (page)
		end

	get_parameter (key: STRING): detachable STRING
		local
			value: detachable WSF_VALUE
		do
			Result := VOID
			value := request.query_parameter (key)
			if attached value then
				Result := value.as_string.value
			end
		end

feature {NONE}

	control: WSF_CONTROL

end
