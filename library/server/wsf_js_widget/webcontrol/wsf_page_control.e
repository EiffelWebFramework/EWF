note
	description: "Summary description for {WSF_PAGE_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_PAGE_CONTROL

feature {NONE} -- Initialization

	make (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Initialize
		do
			request := req
			response := res
			initialize_controls
		end

feature -- Access

	request: WSF_REQUEST
			-- The http request

	response: WSF_RESPONSE
			-- The http response

feature -- Specific implementation

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

feature -- Implementation

	execute
			-- Entry Point: If request is a callback, restore control states and execute handle then return new state json.
			-- If request is not a callback. Run process and render the html page
		local
			event: detachable STRING
			event_parameter: detachable STRING
			event_control_name: detachable STRING
			states: STRING
			states_changes: JSON_OBJECT
			json_parser: JSON_PARSER
		do
			event_control_name := get_parameter ("control_name")
			event := get_parameter ("event")
			event_parameter := get_parameter ("event_parameter")
			if attached event and attached event_control_name and attached control then
				create states.make_empty
				request.read_input_data_into (states)
				create json_parser.make_parser (states)
				if attached {JSON_OBJECT} json_parser.parse_json as sp then
					if attached {JSON_OBJECT} sp.item ("controls") as ct and then attached {JSON_OBJECT} ct.item (control.control_name) as value_state then
						control.load_state (value_state)
					end
				end
				control.handle_callback (event_control_name, event, event_parameter)
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
			data.append ("</head><body data-name=%"" + control_name + "%" data-type=%"WSF_PAGE_CONTROL%">")
			data.append (control.render)
			data.append ("<script src=%"/jquery.min.js%"></script>")
			data.append ("<script src=%"/typeahead.min.js%"></script>")
			data.append ("<script src=%"/widget.js%"></script>")
			data.append ("<script type=%"text/javascript%">$(function() {var page= new WSF_PAGE_CONTROL(")
			data.append (full_state.representation)
			data.append (");page.attach_events();});</script>")
			data.append ("</body></html>")
			create page.make
			page.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html; charset=ISO-8859-1"]>>)
			page.set_body (data)
			response.send (page)
		end

	control_name: STRING
		do
			Result := request.request_time_stamp.out
		end

	state: JSON_OBJECT
		do
			create Result.make
			Result.put (create {JSON_STRING}.make_json (control_name), "id")
			Result.put (create {JSON_STRING}.make_json (request.path_info), "url")
			Result.put (create {JSON_STRING}.make_json (request.query_string), "url_params")
		end

	full_state: JSON_OBJECT
		local
			controls_state: JSON_OBJECT
		do
			create Result.make
			create controls_state.make
			controls_state.put (control.full_state, control.control_name)
			Result.put (controls_state, "controls")
			Result.put (state, "state")
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

feature {NONE} -- Root control

	control: WSF_CONTROL
			-- The root control of this page

end
