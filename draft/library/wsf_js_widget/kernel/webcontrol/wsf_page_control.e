note
	description: "[
		The skeleton for a page control which represents a single page
		of the web application. This class is the starting point for
		event distribution, rendering and state handling.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_PAGE_CONTROL

inherit

	WSF_CONTROL
		rename
			make as make_control
		redefine
			control_name,
			full_state,
			read_state_changes
		end

feature {NONE} -- Initialization

	make (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			make_with_base_path (req, res, "/")
		end

	make_with_base_path (req: WSF_REQUEST; res: WSF_RESPONSE; a_base_path: STRING_32)
			-- Initialize
		do
			base_path := a_base_path
			control_name := req.request_time_stamp.out
			make_control ("body")
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
			event: detachable STRING_32
			event_parameter: detachable ANY
			event_control_name: detachable STRING_32
			states: STRING_32
			states_changes: WSF_JSON_OBJECT
			json_parser: JSON_PARSER
		do
			event_control_name := get_parameter ("control_name")
			event := get_parameter ("event")
			event_parameter := get_parameter ("event_parameter")
			if attached event and attached event_control_name and attached control then
				if not event.is_equal ("uploadfile") then
					create states.make_empty
					request.read_input_data_into (states)
					create json_parser.make_parser (states)
					if attached {JSON_OBJECT} json_parser.parse_json as sp then
						set_state (sp)
					end
				else
					if attached request.form_parameter ("state") as statedata then
						create json_parser.make_parser (statedata.as_string.value)
						if attached {JSON_OBJECT} json_parser.parse_json as sp then
							set_state (sp)
						end
					end
					event_parameter := request.uploaded_files
				end
				handle_callback (event_control_name.split ('-'), event, event_parameter)
				create states_changes.make
				read_state_changes (states_changes)
				response.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "application/json; charset=ISO-8859-1"]>>)
				response.put_string (states_changes.representation)
			else
				process
				render_page
			end
		end

	render_page
			-- Render and send the HTML Page
		local
			page: WSF_PAGE_RESPONSE
		do
			create page.make
			page.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html; charset=ISO-8859-1"]>>)
			page.set_body (render)
			response.send (page)
		end

	render: STRING_32
		local
			ajax: BOOLEAN
		do
			ajax := attached get_parameter ("ajax")
			create Result.make_empty
			if not ajax then
				Result.append ("<html><head>")
				Result.append ("<link href=%"")
				Result.append (base_path)
				Result.append ("assets/bootstrap.min.css%" rel=%"stylesheet%">")
				Result.append ("<link href=%"")
				Result.append (base_path)
				Result.append ("assets/widget.css%" rel=%"stylesheet%">")
				Result.append ("</head><body data-name=%"" + control_name + "%" data-type=%"WSF_PAGE_CONTROL%">")
				Result.append (control.render)
				Result.append ("<script src=%"")
				Result.append (base_path)
				Result.append ("assets/jquery.min.js%"></script>")
				Result.append ("<script src=%"")
				Result.append (base_path)
				Result.append ("assets/widget.js%"></script>")
				Result.append ("<script type=%"text/javascript%">$(function() {var page= new WSF_PAGE_CONTROL(")
				Result.append (full_state.representation)
				Result.append (");page.initialize();});</script>")
				Result.append ("</body></html>")
			else
				Result.append ("<div data-name=%"" + control_name + "%" data-type=%"WSF_PAGE_CONTROL%">")
				Result.append (control.render)
				Result.append ("<script type=%"text/javascript%">$(function() {var page= new WSF_PAGE_CONTROL(")
				Result.append (full_state.representation)
				Result.append (");page.initialize();});</script>")
				Result.append ("</div>")
			end
		end

	read_state_changes (states: WSF_JSON_OBJECT)
			-- Add a new entry in the `states_changes` JSON object with the `control_name` as key and the `state` as value
		do
			Precursor (states)
			control.read_state_changes (states)
		end

	get_parameter (key: STRING_32): detachable STRING_32
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

feature -- Event handling

	handle_callback (cname: LIST [STRING_32]; event: STRING_32; event_parameter: detachable ANY)
			-- Forward callback to control
		do
			control.handle_callback (cname, event, event_parameter)
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	state: WSF_JSON_OBJECT
		do
			create Result.make
			Result.put_string (control_name, "id")
			Result.put_string (request.path_info, "url")
			Result.put_string (request.query_string, "url_params")
		end

	set_state (sp: JSON_OBJECT)
		do
			if attached {JSON_OBJECT} sp.item ("controls") as ct and then attached {JSON_OBJECT} ct.item (control.control_name) as value_state then
				control.load_state (value_state)
			end
		end

	full_state: WSF_JSON_OBJECT
		local
			controls_state: WSF_JSON_OBJECT
		do
			create Result.make
			create controls_state.make
			controls_state.put (control.full_state, control.control_name)
			Result.put (controls_state, "controls")
			Result.put (state, "state")
		end

feature

	control_name: STRING_32

	base_path: STRING_32

feature {NONE} -- Root control

	control: WSF_CONTROL
			-- The root control of this page

end
