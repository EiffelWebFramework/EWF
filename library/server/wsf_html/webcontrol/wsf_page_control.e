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
			-- Initalize all the controls, all the event handles must be set in this function.
		deferred
		ensure
			attached control
		end

	process
			-- Function called on page load (not on callback)
		deferred
		end

feature

	execute
			-- Entry Point: If request is a callback, restore control states and execute handle then return new state json.
			-- If request is not a callback. Run process and render the html page
		local
			event: detachable STRING
			event_parameter: detachable STRING
			control_name: detachable STRING
			states: detachable STRING
			states_changes: JSON_OBJECT
			json_parser: JSON_PARSER
		do
			control_name := get_parameter ("control_name")
			event := get_parameter ("event")
			event_parameter := get_parameter ("event_parameter")
			states := get_parameter ("states")
			if attached event and attached control_name and attached control and attached states then
				create json_parser.make_parser (states)
				if attached {JSON_OBJECT} json_parser.parse_json as sp then
					control.load_state (sp)
				end
				control.handle_callback (control_name, event, event_parameter)
				create states_changes.make
				control.read_state_changes (states_changes)
				response.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "application/json; charset=ISO-8859-1"]>>)
				response.put_string (states_changes.representation)
			else
				process
				render
			end
		end

	render
			-- Render and send the HTML Page
		local
			data: STRING
			page: WSF_PAGE_RESPONSE
			states: JSON_OBJECT
		do
			data := "<html><head>"
			data.append ("<link href=%"/bootstrap.min.css%" rel=%"stylesheet%">")
			data.append ("<link href=%"/widget.css%" rel=%"stylesheet%">")
			data.append ("</head><body>")
			data.append (control.render)
			data.append ("<script type=%"text/javascript%">window.states=")
			create states.make
			control.read_state (states)
			data.append (states.representation)
			data.append (";</script>")
			data.append ("<script src=%"//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js%"></script>")
			data.append ("<script src=%"//cdnjs.cloudflare.com/ajax/libs/typeahead.js/0.9.3/typeahead.min.js%"></script>")
			data.append ("<script src=%"/widget.js%"></script>")
			data.append ("</body></html>")
			create page.make
			page.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html; charset=ISO-8859-1"]>>)
			page.set_body (data)
			response.send (page)
		end

	get_parameter (key: STRING): detachable STRING
			-- Read query parameter as string
		local
			value: detachable WSF_VALUE
		do
			Result := VOID
			value := request.query_parameter (key)
			if attached value and then value.is_string then
				Result := value.as_string.value
			end
		end

feature {NONE}

	control: WSF_CONTROL

end
