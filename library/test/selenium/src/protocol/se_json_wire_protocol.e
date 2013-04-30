note
	description: "Summary description for {SE_JSON_WIRE_PROTOCOL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=SELINIUM", "protocol=selenium", "src=https://code.google.com/p/selenium/wiki/JsonWireProtocol"

class
	SE_JSON_WIRE_PROTOCOL

inherit

	JSON_HELPER

	SE_JSON_WIRE_PROTOCOL_COMMANDS

create
	make, make_with_host

feature -- Initialization

	make
			--
		local
			h: LIBCURL_HTTP_CLIENT
		do
			create h.make
			host := "http://127.0.0.1:4444/wd/hub/"
			initialize_executor
		end

	make_with_host (a_host: STRING_32)
			--
		local
			h: LIBCURL_HTTP_CLIENT
		do
			create h.make
			host := a_host
			initialize_executor
		end

feature -- Access

	has_error: BOOLEAN
			-- Did an error occur in the last request?
			-- There are two types of errors: invalid requests and failed commands.

	last_error: detachable SE_ERROR

feature -- Commands

	status: detachable SE_STATUS
			-- GET /status
			-- Query the server's current status.
			-- The server should respond with a general "HTTP 200 OK" response if it is alive and accepting commands.
			-- The response body should be a JSON object describing the state of the server.
			-- All server implementations should return two basic objects describing the server's current platform and when the server was built.
			-- All fields are optional; if omitted, the client should assume the value is uknown.
			-- Furthermore, server implementations may include additional fields not listed here.
		local
			response: SE_RESPONSE
		do
			if commnad_executor.is_available then
				response := commnad_executor.status
				check_response (response)
				if not has_error then
					if attached response.json_response as l_response then
						Result := json_to_se_status (l_response)
					end
				end
			end
		end

	create_session_with_desired_capabilities (capabilities: SE_CAPABILITIES): detachable SE_SESSION
			--	POST /session
			--  Create a new session.
			--  The server should attempt to create a session that most closely matches the desired and required capabilities.
			--	Required capabilities have higher priority than desired capabilities and must be set for the session to be created.
			--	JSON Parameters:
			--			desiredCapabilities - {object} An object describing the session's desired capabilities.
			--			requiredCapabilities - {object} An object describing the session's required capabilities (Optional).
			--	Returns:
			--			A 302 See Other redirect to /session/:sessionId, where :sessionId is the ID of the newly created session.
			--	Potential Errors:
			--			SessionNotCreatedException - If a required capability could not be set.
		local
			response: SE_RESPONSE
		do
				-- TODO, update the status of the server
				-- SE_STATUS
				-- SE_ERROR
				-- create an COMMAND_EXECUTOR
			if commnad_executor.is_available then
				if attached to_json (capabilities) as l_json then
					response := commnad_executor.new_session (desired_capabilities (l_json.representation))
					check_response (response)
					if not has_error then
						if attached response.json_response as r_value then
							Result := new_session (r_value, "session")
						end
					end
				end
			end
		end

	sessions: detachable LIST [SE_SESSION]
			-- GET /sessions
			-- Returns a list of the currently active sessions. Each session will be returned as a list of JSON objects with the following keys:
			--		id	 			 string	 The session ID.
			--		capabilities	 object	 An object describing the session's capabilities.
			-- Returns:
			--		{Array.<Object>} A list of the currently active sessions.

		local
			response: SE_RESPONSE
			index: INTEGER
		do
			if commnad_executor.is_available then
				response := commnad_executor.sessions
				check_response (response)
				if not has_error then
					if attached response.value as l_value and then attached {JSON_ARRAY} string_to_json (l_value) as l_json_array then
						create {ARRAYED_LIST [SE_SESSION]} Result.make (10)
						from
							index := 1
						until
							index > l_json_array.count
						loop
							if attached {JSON_OBJECT} l_json_array.i_th (index) as json_obj then
								if attached new_session (json_obj.representation, "sessions") as l_session then
									Result.force (l_session)
								end
							end
							index := index + 1
						end
					end
				end
			end
		end

	retrieve_session (a_session_id: STRING_32): detachable SE_SESSION
			--	GET /session/:sessionId
			--	Retrieve the capabilities of the specified session.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{object} An object describing the session's capabilities.
		local
			response: SE_RESPONSE
		do
			if commnad_executor.is_available then
				response := commnad_executor.retrieve_session (a_session_id)
				check_response (response)
				if not has_error then
					if attached response.json_response as r_value then
						Result := new_session (r_value, "session")
					end
				end
			end
		end

	delete_session (a_session_id: STRING)
			--	DELETE /session/:sessionId
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.delete_session (a_session_id)
				check_response (resp)
			end
		end

	set_session_timeouts (a_session_id: STRING_32; a_timeout_type: SE_TIMEOUT_TYPE)
			--	POST /session/:sessionId/timeouts
			--	Configure the amount of time that a particular type of operation can execute for before they are aborted and a |Timeout| error is returned to the client.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		type - {string} The type of operation to set the timeout for. Valid values are: "script" for script timeouts, "implicit" for modifying the implicit wait timeout and "page load" for setting a page load timeout.
			--		ms - {number} The amount of time, in milliseconds, that time-limited commands are permitted to run.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				if attached to_json (a_timeout_type) as l_json then
					resp := commnad_executor.set_session_timeouts (a_session_id, l_json.representation)
					check_response (resp)
				end
			end
		end

	set_session_timeouts_async_script (a_session_id: STRING_32; ms: INTEGER_32)
			--	POST /session/:sessionId/timeouts/async_script
			--	Set the amount of time, in milliseconds, that asynchronous scripts executed by /session/:sessionId/execute_async
			--	are permitted to run before they are aborted and a |Timeout| error is returned to the client.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		ms - {number} The amount of time, in milliseconds, that time-limited commands are permitted to run.
		local
			l_timeout: SE_TIMEOUT_TYPE
			resp: SE_RESPONSE
		do
			create l_timeout.make_empty
			l_timeout.set_ms (ms)
			if commnad_executor.is_available then
				if attached to_json (l_timeout) as l_json then
					resp := commnad_executor.set_session_timeouts_async_script (a_session_id, l_json.representation)
					check_response (resp)
				end
			end
		end

	set_session_timeouts_implicit_wait (a_session_id: STRING_32; ms: NATURAL_32)
			--	POST /session/:sessionId/timeouts/implicit_wait
			--	Set the amount of time the driver should wait when searching for elements. When searching for a single element, the driver should poll the page until an element is found or the timeout expires, whichever occurs first. When searching for multiple elements, the driver should poll the page until at least one element is found or the timeout expires, at which point it should return an empty list.
			--	If this command is never sent, the driver should default to an implicit wait of 0ms.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		ms - {number} The amount of time to wait, in milliseconds. This value has a lower bound of 0.
		local
			l_timeout: SE_TIMEOUT_TYPE
			resp: SE_RESPONSE
		do
			create l_timeout.make_empty
			l_timeout.set_ms (ms.as_integer_32)
			if commnad_executor.is_available then
				if attached to_json (l_timeout) as l_json then
					resp := commnad_executor.set_session_timeouts_implicit_wait (a_session_id, l_json.representation)
					check_response (resp)
				end
			end
		end

	retrieve_window_handle (a_session_id: STRING_32): detachable STRING_32
			--	GET /session/:sessionId/window_handle
			--	Retrieve the current window handle.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{string} The current window handle.
			--Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.retrieve_window_handle (a_session_id)
				check_response (resp)
				if not has_error then
					if attached resp.value as l_value then
						Result := l_value
					end
				end
			end
		end

	retrieve_window_handles (a_session_id: STRING_32): detachable LIST [STRING_32]
			--	GET /session/:sessionId/window_handles
			--	Retrieve the list of all window handles available to the session.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{Array.<string>} A list of window handles.

		local
			resp: SE_RESPONSE
			index: INTEGER_32
		do
			if commnad_executor.is_available then
				resp := commnad_executor.retrieve_window_handles (a_session_id)
				check_response (resp)
				if not has_error then
					if attached resp.value as l_value and then attached {JSON_ARRAY} string_to_json (l_value) as l_json_array then
						create {ARRAYED_LIST [STRING_32]} Result.make (10)
						from
							index := 1
						until
							index > l_json_array.count
						loop
							if attached {JSON_STRING} l_json_array.i_th (index) as json_str then
								Result.force (json_str.representation)
							end
							index := index + 1
						end
					end
				end
			end
		end

	retrieve_url (a_session_id: STRING_32): detachable STRING_32
			--	GET /session/:sessionId/url
			--	Retrieve the URL of the current page.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{string} The current URL.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.retrieve_url (a_session_id)
				check_response (resp)
				if has_error then
					if attached resp.value as l_value then
						Result := l_value
					end
				end
			end
		end

	navigate_to_url (a_session_id: STRING_32; an_url: STRING_32)
			--	POST /session/:sessionId/url
			--	Navigate to a new URL.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		url - {string} The URL to navigate to.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		local
			l_json: STRING_32
			resp: SE_RESPONSE
		do
			l_json := "[
				{ "url": "$url" }
			]"
			l_json.replace_substring_all ("$url", an_url)
			if commnad_executor.is_available then
				resp := commnad_executor.navigate_to_url (a_session_id, l_json)
				check_response (resp)
			end
		end

	forward (a_session_id: STRING_32)
			--	POST /session/:sessionId/forward
			--	Navigate forwards in the browser history, if possible.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.forward (a_session_id)
				check_response (resp)
			end
		end

	back (a_session_id: STRING_32)
			--	POST /session/:sessionId/back
			--	Navigate backwards in the browser history, if possible.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.back (a_session_id)
				check_response (resp)
			end
		end

	refresh (a_session_id: STRING_32)
			--	POST /session/:sessionId/refresh
			--	Refresh the current page.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.refresh (a_session_id)
				check_response (resp)
			end
		end

	execute (a_session_id: STRING_32)
			--	POST /session/:sessionId/execute
			--	Inject a snippet of JavaScript into the page for execution in the context of the currently selected frame.
			--	The executed script is assumed to be synchronous and the result of evaluating the script is returned to the client.
			--	The script argument defines the script to execute in the form of a function body. The value returned by that function will be returned to the client.
			--	The function will be invoked with the provided args array and the values may be accessed via the arguments object in the order specified.

			--	Arguments may be any JSON-primitive, array, or JSON object. JSON objects that define a
			-- 	WebElement reference will be converted to the corresponding DOM element.
			-- 	Likewise, any WebElements in the script result will be returned to the client as WebElement JSON objects.

			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		script - {string} The script to execute.
			--		args - {Array.<*>} The script arguments.
			--	Returns:
			--		{*} The script result.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
			--		StaleElementReference - If one of the script arguments is a WebElement that is not attached to the page's DOM.
			--		JavaScriptError - If the script throws an Error.
		do
				--TODO
		end

	execute_async (a_session_id: STRING_32)
			--	POST /session/:sessionId/execute_async
			--	Inject a snippet of JavaScript into the page for execution in the context of the currently selected frame. The executed script is assumed to be asynchronous and must signal that is done by invoking the provided callback, which is always provided as the final argument to the function. The value to this callback will be returned to the client.
			--	Asynchronous script commands may not span page loads. If an unload event is fired while waiting for a script result, an error should be returned to the client.
			--	The script argument defines the script to execute in teh form of a function body. The function will be invoked with the provided args array and the values may be accessed via the arguments object in the order specified. The final argument will always be a callback function that must be invoked to signal that the script has finished.
			--	Arguments may be any JSON-primitive, array, or JSON object. JSON objects that define a WebElement reference will be converted to the corresponding DOM element. Likewise, any WebElements in the script result will be returned to the client as WebElement JSON objects.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		script - {string} The script to execute.
			--		args - {Array.<*>} The script arguments.
			--	Returns:
			--		{*} The script result.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
			--		StaleElementReference - If one of the script arguments is a WebElement that is not attached to the page's DOM.
			--		Timeout - If the script callback is not invoked before the timout expires. Timeouts are controlled by the /session/:sessionId/timeout/async_script command.
			--		JavaScriptError - If the script throws an Error or if an unload event is fired while waiting for the script to finish.
		do
				--TODO
		end

	screenshot (a_session_id: STRING_32): detachable STRING_32
			--	GET /session/:sessionId/screenshot
			--	Take a screenshot of the current page.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{string} The screenshot as a base64 encoded PNG.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.screenshot (a_session_id)
				check_response (resp)
				if not has_error then
					if attached resp.value as l_value then
						Result := l_value
					end
				end
			end
		end

	ime_available_engines (a_session_id: STRING_32): detachable LIST [STRING_32]
			--	GET /session/:sessionId/ime/available_engines
			--	List all available engines on the machine. To use an engine, it has to be present in this list.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{Array.<string>} A list of available engines
			--	Potential Errors:
			--		ImeNotAvailableException - If the host does not support IME
		local
			resp: SE_RESPONSE
			index: INTEGER_32
		do
			if commnad_executor.is_available then
				resp := commnad_executor.ime_available_engines (a_session_id)
				check_response (resp)
				if not has_error then
					if attached resp.value as l_value and then attached {JSON_ARRAY} string_to_json (l_value) as l_json_array then
						create {ARRAYED_LIST [STRING_32]} Result.make (10)
						from
							index := 1
						until
							index > l_json_array.count
						loop
							if attached {JSON_STRING} l_json_array.i_th (index) as json_str then
								Result.force (json_str.representation)
							end
							index := index + 1
						end
					end
				end
			end
		end

	ime_active_engine (a_session_id: STRING_32): detachable STRING_32
			--	GET /session/:sessionId/ime/active_engine
			--	Get the name of the active IME engine. The name string is platform specific.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{string} The name of the active IME engine.
			--	Potential Errors:
			--		ImeNotAvailableException - If the host does not support IME
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.ime_active_engine (a_session_id)
				check_response (resp)
				if not has_error then
					if attached resp.value as l_value then
						Result := l_value
					end
				end
			end
		end

	ime_activated (a_session_id: STRING_32): BOOLEAN
			--	GET /session/:sessionId/ime/activated
			--	Indicates whether IME input is active at the moment (not if it's available.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{boolean} true if IME input is available and currently active, false otherwise
			--	Potential Errors:
			--		ImeNotAvailableException - If the host does not support IME
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.ime_active_engine (a_session_id)
				check_response (resp)
				if not has_error then
					if attached {BOOLEAN} resp.value as l_value then
						Result := l_value
					end
				end
			end
		end

	ime_deactivate (a_session_id: STRING_32)
			--	POST /session/:sessionId/ime/deactivate
			--	De-activates the currently-active IME engine.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Potential Errors:
			--		ImeNotAvailableException - If the host does not support IME
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.ime_deactivate (a_session_id)
				check_response (resp)
			end
		end

	ime_activate (a_session_id: STRING_32; an_engine: STRING_32)
			--	POST /session/:sessionId/ime/activate
			--	Make an engines that is available (appears on the list returned by getAvailableEngines) active. After this call, the engine will be added to the list of engines loaded in the IME daemon and the input sent using sendKeys will be converted by the active engine. Note that this is a platform-independent method of activating IME (the platform-specific way being using keyboard shortcuts
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		engine - {string} Name of the engine to activate.
			--	Potential Errors:
			--		ImeActivationFailedException - If the engine is not available or if the activation fails for other reasons.
			--		ImeNotAvailableException - If the host does not support IME
		local
			l_json: STRING_32
			resp: SE_RESPONSE
		do
			l_json := "[
				{ "engine": $engine }
			]"
			l_json.replace_substring_all ("$engine", an_engine)
			if commnad_executor.is_available then
				resp := commnad_executor.ime_activate (a_session_id, l_json)
				check_response (resp)
			end
		end

	frame (a_session_id: STRING_32;  arg : detachable STRING_32)
			--	POST /session/:sessionId/frame
			--	Change focus to another frame on the page. If the frame id is null, the server should switch to the page's default content.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		id - {string|number|null|WebElement JSON Object} Identifier for the frame to change focus to.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
			--		NoSuchFrame - If the frame specified by id cannot be found.
		local
			l_json: STRING_32
			resp: SE_RESPONSE
		do
			l_json := "[
				{ "id": $id }
			]"
			if attached arg as l_arg then
				l_json.replace_substring_all ("$id", l_arg)
			else
				l_json.replace_substring_all ("$id", "null")
			end

			if commnad_executor.is_available then
				resp := commnad_executor.frame (a_session_id, l_json)
				check_response (resp)
			end
		end

	change_focus_window (a_session_id: STRING_32; a_name: STRING_32)
			--	POST /session/:sessionId/window
			--	Change focus to another window. The window to change focus to may be specified by its server assigned window handle, or by the value of its name attribute.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		name - {string} The window to change focus to.
			--	Potential Errors:
			--		NoSuchWindow - If the window specified by name cannot be found.
		local
			l_json: STRING_32
			resp: SE_RESPONSE
		do
			l_json := "[
				{ "name": "$name" }
			]"
			l_json.replace_substring_all ("$name", a_name)
			if commnad_executor.is_available then
				resp := commnad_executor.change_focus_window (a_session_id, l_json)
				check_response (resp)
			end
		end

	close_window (a_session_id: STRING_32)
			--	DELETE /session/:sessionId/window
			--	Close the current window.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window is already closed
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.close_window (a_session_id)
				check_response (resp)
			end
		end

	change_size_window (a_session_id: STRING_32; a_window_handle: STRING_32; a_width: NATURAL_32; a_height: NATURAL_32)
			--	POST /session/:sessionId/window/:windowHandle/size
			--	Change the size of the specified window. If the :windowHandle URL parameter is "current", the currently active window will be resized.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		width - {number} The new window width.
			--		height - {number} The new window height.
		local
			l_json: STRING_32
			resp: SE_RESPONSE
		do
			l_json := "[
				{ "width": $width,
				  "height": $height
				}
			]"
			l_json.replace_substring_all ("$width", a_width.out)
			l_json.replace_substring_all ("$height", a_height.out)
			if commnad_executor.is_available then
				resp := commnad_executor.change_size_window (a_session_id, a_window_handle, l_json)
				check_response (resp)
			end
		end

	size_window (a_session_id: STRING_32; a_window_handle: STRING_32): SE_DIMENSION
			--	GET /session/:sessionId/window/:windowHandle/size
			--	Get the size of the specified window. If the :windowHandle URL parameter is "current", the size of the currently active window will be returned.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{width: number, height: number} The size of the window.
			--	Potential Errors:
			--		NoSuchWindow - If the specified window cannot be found.
		local
			resp: SE_RESPONSE
		do
			create Result
			if commnad_executor.is_available then
				resp := commnad_executor.size_window (a_session_id, a_window_handle)
				check_response (resp)
				if not has_error then
					if attached resp.value as l_value and then attached {JSON_OBJECT} string_to_json (l_value) as l_json_object then
						if attached l_json_object.item ("width") as l_width then
							Result.set_width (l_width.representation.to_natural_32)
						end
						if attached l_json_object.item ("height") as l_height then
							Result.set_width (l_height.representation.to_natural_32)
						end
					end
				end
			end
		end

	change_window_position (a_session_id: STRING_32; a_window_handle: STRING_32; an_x: INTEGER_32; an_y: INTEGER_32)
			--	POST /session/:sessionId/window/:windowHandle/position
			--	Change the position of the specified window. If the :windowHandle URL parameter is "current", the currently active window will be moved.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		x - {number} The X coordinate to position the window at, relative to the upper left corner of the screen.
			--		y - {number} The Y coordinate to position the window at, relative to the upper left corner of the screen.
			--	Potential Errors:
			--		NoSuchWindow - If the specified window cannot be found.
		local
			l_json: STRING_32
			resp: SE_RESPONSE
		do
			l_json := "[
				{ "x": $x,
				  "y": $y
				}
			]"
			l_json.replace_substring_all ("$x", an_x.out)
			l_json.replace_substring_all ("$y", an_y.out)
			if commnad_executor.is_available then
				resp := commnad_executor.change_window_position (a_session_id, a_window_handle, l_json)
				check_response (resp)
			end
		end

	window_position (a_session_id: STRING_32; a_window_handle: STRING_32): SE_POINT
			--	GET /session/:sessionId/window/:windowHandle/position
			--	Get the position of the specified window. If the :windowHandle URL parameter is "current", the position of the currently active window will be returned.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{x: number, y: number} The X and Y coordinates for the window, relative to the upper left corner of the screen.
			--	Potential Errors:
			--		NoSuchWindow - If the specified window cannot be found.
		local
			resp: SE_RESPONSE
		do
			create Result
			if commnad_executor.is_available then
				resp := commnad_executor.window_position (a_session_id, a_window_handle)
				check_response (resp)
				if not has_error then
					if attached resp.value as l_value and then attached {JSON_OBJECT} string_to_json (l_value) as l_json_object then
						if attached l_json_object.item ("x") as l_x then
							Result.set_x (l_x.representation.to_integer_32)
						end
						if attached l_json_object.item ("y") as l_y then
							Result.set_y (l_y.representation.to_integer_32)
						end
					end
				end
			end
		end

	window_maximize (a_session_id: STRING_32; a_window_handle: STRING_32)
			--	POST /session/:sessionId/window/:windowHandle/maximize
			--	Maximize the specified window if not already maximized. If the :windowHandle URL parameter is "current", the currently active window will be maximized.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Potential Errors:
			--		NoSuchWindow - If the specified window cannot be found.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.window_maximize (a_session_id, a_window_handle)
				check_response (resp)
			end
		end

	retrieve_cookies (a_session_id: STRING_32): detachable LIST [SE_COOKIE]
			--	GET /session/:sessionId/cookie
			--	Retrieve all cookies visible to the current page.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{Array.<object>} A list of cookies.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		local
			resp: SE_RESPONSE
			index: INTEGER
		do
				-- Check the format of internal json object
			if commnad_executor.is_available then
				resp := commnad_executor.retrieve_cookies (a_session_id)
				check_response (resp)
				if not has_error then
					if attached resp.value as l_value and then attached {JSON_ARRAY} string_to_json (l_value) as l_json_array then
						create {ARRAYED_LIST [SE_COOKIE]} Result.make (10)
						from
							index := 1
						until
							index > l_json_array.count
						loop
							if attached {JSON_VALUE} l_json_array.i_th (index) as json_str then
								if attached json_to_se_cookie (json_str.representation) as l_item then
									Result.force (l_item)
								end
							end
							index := index + 1
						end
					end
				end
			end
		end

	set_cookie (a_session_id: STRING_32; a_cookie: SE_COOKIE)
			--	POST /session/:sessionId/cookie
			--	Set a cookie. If the cookie path is not specified, it should be set to "/". Likewise, if the domain is omitted, it should default to the current page's domain.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		cookie - {object} A JSON object defining the cookie to add.
		local
			l_data: STRING_32
			response: SE_RESPONSE
		do
			l_data := "[
				{ "cookie":	$cookie}
			]"
			if commnad_executor.is_available then
				if attached to_json (a_cookie) as l_json then
					l_data.replace_substring_all ("$cookie", l_json.representation)
					response := commnad_executor.set_cookie (a_session_id, l_data)
					check_response (response)
				end
			end
		end

	delete_cookies (a_session_id: STRING_32)
			--	DELETE /session/:sessionId/cookie
			--	Delete all cookies visible to the current page.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Potential Errors:
			--		InvalidCookieDomain - If the cookie's domain is not visible from the current page.
			--		NoSuchWindow - If the currently selected window has been closed.
			--		UnableToSetCookie - If attempting to set a cookie on a page that does not support cookies (e.g. pages with mime-type text/plain).
		local
			response: SE_RESPONSE
		do
			if commnad_executor.is_available then
				response := commnad_executor.delete_cookies (a_session_id)
				check_response (response)
			end
		end

	delete_cookie_by_name (a_session_id: STRING_32; a_name: STRING_32)
			--	DELETE /session/:sessionId/cookie/:name
			--	Delete the cookie with the given name. This command should be a no-op if there is no such cookie visible to the current page.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--		:name - The name of the cookie to delete.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		local
			response: SE_RESPONSE
		do
			if commnad_executor.is_available then
				response := commnad_executor.delete_cookie_by_name (a_session_id, a_name)
				check_response (response)
			end
		end

	page_source (a_session_id: STRING_32): detachable STRING_32
			--	GET /session/:sessionId/source
			--	Get the current page source.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{string} The current page source.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.page_source (a_session_id)
				check_response (resp)
				if not has_error then
					if attached resp.value as l_value then
						Result := l_value
					end
				end
			end
		end

	page_title (a_session_id: STRING_32): detachable STRING_32
			--	GET /session/:sessionId/title
			--	Get the current page title.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{string} The current page title.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.page_title (a_session_id)
				check_response (resp)
				if not has_error then
					if attached resp.value as l_value then
						Result := l_value
					end
				end
			end
		end

	search_element (a_session_id: STRING_32; strategy: STRING_32): detachable WEB_ELEMENT
			-- POST /session/:sessionId/element
			-- Search for an element on the page, starting from the document root. The located element will be returned as a
			-- WebElement JSON object. The table below lists the locator strategies that each server should support.
			-- Each locator must return the first matching element located in the DOM.
			--
			--		Strategy			Description
			--		class name		 	Returns an element whose class name contains the search value; compound class names are not permitted.
			--		css selector	 	Returns an element matching a CSS selector.
			--		id	 				Returns an element whose ID attribute matches the search value.
			--		name	 			Returns an element whose NAME attribute matches the search value.
			--		link text	 		Returns an anchor element whose visible text matches the search value.
			--		partial link text	Returns an anchor element whose visible text partially matches the search value.
			--		tag name	 		Returns an element whose tag name matches the search value.
			--		xpath	 			Returns an element matching an XPath expression.
			--
			-- URL Parameters:
			--  	:sessionId - ID of the session to route the command to.
			-- JSON Parameters:
			--		using - {string} The locator strategy to use.
			--		value - {string} The The search target.
			-- Returns:
			--		{ELEMENT:string} A WebElement JSON object for the located element.
			-- Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
			--		NoSuchElement - If the element cannot be found.
			--		XPathLookupError - If using XPath and the input expression is invalid.
		require
			has_valid_strategy: (create {SE_BY}).is_valid_strategy (strategy)
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.search_element (a_session_id, strategy)
				check_response (resp)
				if not has_error then
					if attached resp.value as l_value and then attached {JSON_OBJECT} string_to_json (l_value) as ll_value and then attached {JSON_STRING} ll_value.item ("ELEMENT") as l_elem then
						create Result.make (l_elem.item, Current, a_session_id)
					end
				end
			end
		end

	search_elements (a_session_id: STRING_32; strategy: STRING_32): detachable LIST [WEB_ELEMENT]
			--	POST /session/:sessionId/elements
			--	Search for multiple elements on the page, starting from the document root. The located elements will be returned as a WebElement JSON objects. The table below lists the locator strategies that each server should support. Elements should be returned in the order located in the DOM.
			--
			--		Strategy			Description
			--		class name		 	Returns an element whose class name contains the search value; compound class names are not permitted.
			--		css selector	 	Returns an element matching a CSS selector.
			--		id	 				Returns an element whose ID attribute matches the search value.
			--		name	 			Returns an element whose NAME attribute matches the search value.
			--		link text	 		Returns an anchor element whose visible text matches the search value.
			--		partial link text	Returns an anchor element whose visible text partially matches the search value.
			--		tag name	 		Returns an element whose tag name matches the search value.
			--		xpath	 			Returns an element matching an XPath expression.
			--
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		using - {string} The locator strategy to use.
			--		value - {string} The The search target.
			--	Returns:
			--		{Array.<{ELEMENT:string}>} A list of WebElement JSON objects for the located elements.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
			--		XPathLookupError - If using XPath and the input expression is invalid.
		require
			has_valid_strategy: (create {SE_BY}).is_valid_strategy (strategy)
		local
			resp: SE_RESPONSE
			index: INTEGER
		do
			if commnad_executor.is_available then
				resp := commnad_executor.search_elements (a_session_id, strategy)
				check_response (resp)
				if not has_error then
					if attached resp.value as l_value and then attached {JSON_ARRAY} string_to_json (l_value) as l_json_array then
						create {ARRAYED_LIST [WEB_ELEMENT]} Result.make (10)
						from
							index := 1
						until
							index > l_json_array.count
						loop
							if attached {JSON_OBJECT} l_json_array.i_th (index) as json_str and then attached json_str.item ("ELEMENT") as l_elem then
								Result.force (create {WEB_ELEMENT}.make (l_elem.representation, Current, a_session_id))
							end
							index := index + 1
						end
					end
				end
			end
		end

	element_active (a_session_id: STRING_32): detachable WEB_ELEMENT
			--	POST /session/:sessionId/element/active
			--	Get the element on the page that currently has focus. The element will be returned as a WebElement JSON object.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{ELEMENT:string} A WebElement JSON object for the active element.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.element_active (a_session_id)
				check_response (resp)
				if not has_error then
					if attached {JSON_OBJECT} resp.value as l_value and then attached l_value.item ("ELEMENT") as l_elem then
						create Result.make (l_elem.representation, Current, a_session_id)
					end
				end
			end
		end

		--	element_id (a_session_id: STRING_32; )
		--			--	GET /session/:sessionId/element/:id
		--			--	Describe the identified element.
		--			--	Note: This command is reserved for future use; its return type is currently undefined.

		--			--	URL Parameters:
		--			--		:sessionId - ID of the session to route the command to.
		--			--		:id - ID of the element to route the command to.
		--			--	Potential Errors:
		--			--		NoSuchWindow - If the currently selected window has been closed.
		--			--		StaleElementReference - If the element referenced by :id is no longer attached to the page's DOM.
		--		do
		--		end

	search_element_id_element (a_session_id: STRING_32; an_id: STRING_32; strategy: STRING_32): detachable WEB_ELEMENT
			--	POST /session/:sessionId/element/:id/element
			--	Search for an element on the page, starting from the identified element.
			--	The located element will be returned as a WebElement JSON object.
			--	The table below lists the locator strategies that each server should support.
			--	Each locator must return the first matching element located in the DOM.
			--
			--		Strategy			Description
			--		class name		 	Returns an element whose class name contains the search value; compound class names are not permitted.
			--		css selector	 	Returns an element matching a CSS selector.
			--		id	 				Returns an element whose ID attribute matches the search value.
			--		name	 			Returns an element whose NAME attribute matches the search value.
			--		link text	 		Returns an anchor element whose visible text matches the search value.
			--		partial link text	Returns an anchor element whose visible text partially matches the search value.
			--		tag name	 		Returns an element whose tag name matches the search value.
			--		xpath	 			Returns an element matching an XPath expression.
			--
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--		:id - ID of the element to route the command to.
			--	JSON Parameters:
			--		using - {string} The locator strategy to use.
			--		value - {string} The The search target.
			--	Returns:
			--		{ELEMENT:string} A WebElement JSON object for the located element.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
			--		StaleElementReference - If the element referenced by :id is no longer attached to the page's DOM.
			--		NoSuchElement - If the element cannot be found.
			--		XPathLookupError - If using XPath and the input expression is invalid.
		require
			has_valid_strategy: (create {SE_BY}).is_valid_strategy (strategy)
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.search_element_id_element (a_session_id, an_id, strategy)
				check_response (resp)
				if not has_error then
					if attached {JSON_OBJECT} resp.value as l_value and then attached l_value.item ("ELEMENT") as l_elem then
						create Result.make (l_elem.representation, Current, a_session_id)
					end
				end
			end
		end

	search_elements_id (a_session_id: STRING_32; an_id: STRING_32; strategy: STRING_32): detachable LIST [WEB_ELEMENT]
			--	POST /session/:sessionId/element/:id/elements
			--	Search for multiple elements on the page, starting from the identified element.
			--	The located elements will be returned as a WebElement JSON objects.
			-- 	The table below lists the locator strategies that each server should support.
			--	Elements should be returned in the order located in the DOM.
			--
			--		Strategy			Description
			--		class name		 	Returns an element whose class name contains the search value; compound class names are not permitted.
			--		css selector	 	Returns an element matching a CSS selector.
			--		id	 				Returns an element whose ID attribute matches the search value.
			--		name	 			Returns an element whose NAME attribute matches the search value.
			--		link text	 		Returns an anchor element whose visible text matches the search value.
			--		partial link text	Returns an anchor element whose visible text partially matches the search value.
			--		tag name	 		Returns an element whose tag name matches the search value.
			--		xpath	 			Returns an element matching an XPath expression.
			--
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--		:id - ID of the element to route the command to.
			--	JSON Parameters:
			--		using - {string} The locator strategy to use.
			--		value - {string} The The search target.
			--	Returns:
			--		{Array.<{ELEMENT:string}>} A list of WebElement JSON objects for the located elements.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
			--		StaleElementReference - If the element referenced by :id is no longer attached to the page's DOM.
			--		XPathLookupError - If using XPath and the input expression is invalid.
		require
			has_valid_strategy: (create {SE_BY}).is_valid_strategy (strategy)
		local
			resp: SE_RESPONSE
			index: INTEGER
		do
			if commnad_executor.is_available then
				resp := commnad_executor.search_element_id_elements (a_session_id, an_id, strategy)
				check_response (resp)
				if not has_error then
					if attached resp.value as l_value and then attached {JSON_ARRAY} string_to_json (l_value) as l_json_array then
						create {ARRAYED_LIST [WEB_ELEMENT]} Result.make (10)
						from
							index := 1
						until
							index > l_json_array.count
						loop
							if attached {JSON_OBJECT} l_json_array.i_th (index) as json_str and then attached json_str.item ("ELEMENT") as l_elem then
								Result.force (create {WEB_ELEMENT}.make (l_elem.representation,Current, a_session_id))
							end
							index := index + 1
						end
					end
				end
			end
		end

	element_click (a_session_id: STRING_32; an_id: STRING_32)
			--	POST /session/:sessionId/element/:id/click
			--	Click on an element.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--		:id - ID of the element to route the command to.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
			--		StaleElementReference - If the element referenced by :id is no longer attached to the page's DOM.
			--		ElementNotVisible - If the referenced element is not visible on the page (either is hidden by CSS, has 0-width, or has 0-height)
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.element_click (a_session_id, an_id)
				check_response (resp)
			end
		end

	element_submit (a_session_id: STRING_32; an_id: STRING_32)
			--	POST /session/:sessionId/element/:id/submit
			--	Submit a FORM element. The submit command may also be applied to any element that is a descendant of a FORM element.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--		:id - ID of the element to route the command to.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
			--		StaleElementReference - If the element referenced by :id is no longer attached to the page's DOM.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.element_submit (a_session_id, an_id)
				check_response (resp)
			end
		end

	element_text (a_session_id: STRING_32; an_id: STRING_32): detachable STRING_32
			--	GET /session/:sessionId/element/:id/text
			--	Returns the visible text for the element.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--		:id - ID of the element to route the command to.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
			--		StaleElementReference - If the element referenced by :id is no longer attached to the page's DOM.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.element_text (a_session_id, an_id)
				check_response (resp)
				if not has_error then
					if attached resp.value as l_value then
						Result := l_value
					end
				end
			end
		end

	send_event (a_session_id: STRING_32; an_id: STRING_32; events: ARRAY [STRING_32])
			--	POST /session/:sessionId/element/:id/value
			--	Send a sequence of key strokes to an element.
			--	Any UTF-8 character may be specified, however, if the server does not support native key events,
			--	it should simulate key strokes for a standard US keyboard layout.
			--	The Unicode Private Use Area code points, 0xE000-0xF8FF, are used to represent pressable, non-text keys (see table below).
			--	Key			Code	Key			Code		Key			Code		Key			Code		Key				Code
			--	NULL		U+E000	Space		U+E00D		Numpad 0	U+E01A		Multiply	U+E024		F1				U+E031
			--	Cancel		U+E001	Pageup		U+E00E		Numpad 1	U+E01B		Add			U+E025		F2				U+E032
			--	Help		U+E002	Pagedown	U+E00F		Numpad 2	U+E01C		Separator	U+E026		F3				U+E033
			--	Back space	U+E003	End			U+E010		Numpad 3	U+E01D		Subtract	U+E027		F4				U+E034
			--	Tab			U+E004	Home		U+E011		Numpad 4	U+E01E		Decimal		U+E028		F5				U+E035
			--	Clear		U+E005	Left arrow	U+E012		Numpad 5	U+E01F		Divide		U+E029		F6				U+E036
			--	Return1		U+E006	Up arrow	U+E013		Numpad 6	U+E020								F7				U+E037
			--	Enter1		U+E007	Right arrow	U+E014		Numpad 7	U+E021								F8				U+E038
			--	Shift		U+E008	Down arrow	U+E015		Numpad 8	U+E022								F9				U+E039
			--	Control		U+E009	Insert		U+E016		Numpad 9	U+E023								F10				U+E03A
			--	Alt			U+E00A	Delete		U+E017														F11				U+E03B
			--	Pause		U+E00B	Semicolon	U+E018														F12				U+E03C
			--	Escape		U+E00C	Equals		U+E019														Command/Meta	U+E03D
			--	1 The return key is not the same as the enter key.
			--	The server must process the key sequence as follows:

			--	Each key that appears on the keyboard without requiring modifiers are sent as a keydown followed by a key up.
			--	If the server does not support native events and must simulate key strokes with JavaScript, it must generate keydown, keypress, and keyup events, in that order. The keypress event should only be fired when the corresponding key is for a printable character.
			--	If a key requires a modifier key (e.g. "!" on a standard US keyboard), the sequence is: modifier down, key down, key up, modifier up, where key is the ideal unmodified key value (using the previous example, a "1").
			--	Modifier keys (Ctrl, Shift, Alt, and Command/Meta) are assumed to be "sticky"; each modifier should be held down (e.g. only a keydown event) until either the modifier is encountered again in the sequence, or the NULL (U+E000) key is encountered.
			--	Each key sequence is terminated with an implicit NULL key. Subsequently, all depressed modifier keys must be released (with corresponding keyup events) at the end of the sequence.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--		:id - ID of the element to route the command to.
			--	JSON Parameters:
			--		value - {Array.<string>} The sequence of keys to type. An array must be provided. The server should flatten the array items to a single string to be typed.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
			--		StaleElementReference - If the element referenced by :id is no longer attached to the page's DOM.
			--		ElementNotVisible - If the referenced element is not visible on the page (either is hidden by CSS, has 0-width, or has 0-height)
		local
			resp: SE_RESPONSE
			l_json: STRING_32
		do
			l_json := "[
				{"value":$array}
			]"
			if commnad_executor.is_available then
				if attached json.value (create {ARRAYED_LIST [STRING_32]}.make_from_array (events)) as l_array then
					l_json.replace_substring_all ("$array", l_array.representation)
					resp := commnad_executor.send_events (a_session_id, an_id, l_json)
					check_response (resp)
				end
			end
		end

	send_key_strokes (a_session_id: STRING_32; keys: ARRAY [STRING_32])
			--	POST /session/:sessionId/keys
			--	Send a sequence of key strokes to the active element. This command is similar to the send keys command in every aspect except the implicit termination: The modifiers are not released at the end of the call. Rather, the state of the modifier keys is kept between calls, so mouse interactions can be performed while modifier keys are depressed.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		value - {Array.<string>} The keys sequence to be sent. The sequence is defined in the send keys command.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		local
			resp: SE_RESPONSE
			l_json: STRING_32
		do
			l_json := "[
				{"value":$array}
			]"
			if commnad_executor.is_available then
				if attached json.value (create {ARRAYED_LIST [STRING_32]}.make_from_array (keys)) as l_array then
					l_json.replace_substring_all ("$array", l_array.representation)
					resp := commnad_executor.send_key_strokes (a_session_id, l_json)
					check_response (resp)
				end
			end
		end

	query_by_tag_name (a_session_id: STRING_32; an_id: STRING_32): detachable STRING_32
			-- 	GET /session/:sessionId/element/:id/name
			-- 	Query for an element's tag name.
			-- 	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			-- 		:id - ID of the element to route the command to.
			--	Returns:
			--		{string} The element's tag name, as a lowercase string.
			-- 	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
			--		StaleElementReference - If the element referenced by :id is no longer attached to the page's DOM.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.query_by_tag_name (a_session_id, an_id)
				check_response (resp)
				if not has_error then
					if attached resp.value as l_value then
						Result := l_value
					end
				end
			end
		end

	clear_element (a_session_id: STRING_32; an_id: STRING_32)
			--	POST /session/:sessionId/element/:id/clear
			--	Clear a TEXTAREA or text INPUT element's value.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--		:id - ID of the element to route the command to.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
			--		StaleElementReference - If the element referenced by :id is no longer attached to the page's DOM.
			--		ElementNotVisible - If the referenced element is not visible on the page (either is hidden by CSS, has 0-width, or has 0-height)
			--		InvalidElementState - If the referenced element is disabled.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.clear_element (a_session_id, an_id)
				check_response (resp)
			end
		end

	is_selected (a_session_id: STRING_32; an_id: STRING_32): BOOLEAN
			--	GET /session/:sessionId/element/:id/selected
			--	Determine if an OPTION element, or an INPUT element of type checkbox or radiobutton is currently selected.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--		:id - ID of the element to route the command to.
			--	Returns:
			--		{boolean} Whether the element is selected.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
			--		StaleElementReference - If the element referenced by :id is no longer attached to the page's DOM.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.is_selected (a_session_id, an_id)
				check_response (resp)
				if not has_error then
					if attached {JSON_BOOLEAN} resp.value as l_value then
						Result := (l_value.item)
					end
				end
			end
		end

	is_enabled (a_session_id: STRING_32; an_id: STRING_32): BOOLEAN
			--	GET /session/:sessionId/element/:id/enabled
			--	Determine if an element is currently enabled.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--		:id - ID of the element to route the command to.
			--	Returns:
			--		{boolean} Whether the element is enabled.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
			--		StaleElementReference - If the element referenced by :id is no longer attached to the page's DOM.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.is_enabled (a_session_id, an_id)
				check_response (resp)
				if not has_error then
					if attached {JSON_BOOLEAN} resp.value as l_value then
						Result := (l_value.item)
					end
				end
			end
		end

	element_value (a_session_id: STRING_32; an_id: STRING_32; a_name: STRING_32): detachable STRING_32
			--	GET /session/:sessionId/element/:id/attribute/:name
			--	Get the value of an element's attribute.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--		:id - ID of the element to route the command to.
			--	Returns:
			--		{string|null} The value of the attribute, or null if it is not set on the element.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
			--		StaleElementReference - If the element referenced by :id is no longer attached to the page's DOM.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.element_value (a_session_id, an_id, a_name)
				check_response (resp)
				if not has_error then
					if attached resp.value as l_value then
						Result := l_value
					end
				end
			end
		end

	elements_equals (a_session_id: STRING_32; an_id: STRING_32; an_other: STRING_32): BOOLEAN
			--	GET /session/:sessionId/element/:id/equals/:other
			--	Test if two element IDs refer to the same DOM element.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--		:id - ID of the element to route the command to.
			--		:other - ID of the element to compare against.
			--	Returns:
			--		{boolean} Whether the two IDs refer to the same element.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
			--		StaleElementReference - If either the element refered to by :id or :other is no longer attached to the page's DOM.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.element_equals (a_session_id, an_id, an_other)
				check_response (resp)
				if not has_error then
					if attached {JSON_BOOLEAN} resp.value as l_value then
						Result := (l_value.item)
					end
				end
			end
		end

	is_displayed (a_session_id: STRING_32; an_id: STRING_32): BOOLEAN
			--	GET /session/:sessionId/element/:id/displayed
			--	Determine if an element is currently displayed.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--		:id - ID of the element to route the command to.
			--	Returns:
			--		{boolean} Whether the element is displayed.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
			--		StaleElementReference - If the element referenced by :id is no longer attached to the page's DOM.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.is_displayed (a_session_id, an_id)
				check_response (resp)
				if not has_error then
					if attached {JSON_BOOLEAN} resp.value as l_value then
						Result := (l_value.item)
					end
				end
			end
		end

	element_location (a_session_id: STRING_32; an_id: STRING_32): SE_POINT
			--	GET /session/:sessionId/element/:id/location
			--	Determine an element's location on the page. The point (0, 0) refers to the upper-left corner of the page.
			-- 	The element's coordinates are returned as a JSON object with x and y properties.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--		:id - ID of the element to route the command to.
			--	Returns:
			--		{x:number, y:number} The X and Y coordinates for the element on the page.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
			--		StaleElementReference - If the element referenced by :id is no longer attached to the page's DOM.
		local
			resp: SE_RESPONSE
		do
			create Result
			if commnad_executor.is_available then
				resp := commnad_executor.element_location (a_session_id, an_id)
				check_response (resp)
				if not has_error then
					if attached resp.value as l_value and then attached {JSON_OBJECT} string_to_json (l_value) as l_json_object then
						if attached l_json_object.item ("x") as l_x then
							Result.set_x (l_x.representation.to_integer_32)
						end
						if attached l_json_object.item ("y") as l_y then
							Result.set_y (l_y.representation.to_integer_32)
						end
					end
				end
			end
		end

	location_in_view (a_session_id: STRING_32; an_id: STRING_32): SE_POINT
			--	GET /session/:sessionId/element/:id/location_in_view
			--	Determine an element's location on the screen once it has been scrolled into view.
			--	Note: This is considered an internal command and should only be used to determine an element's
			-- 	location for correctly generating native events.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--		:id - ID of the element to route the command to.
			--	Returns:
			--		{x:number, y:number} The X and Y coordinates for the element.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
			--		StaleElementReference - If the element referenced by :id is no longer attached to the page's DOM.
		local
			resp: SE_RESPONSE
		do
			create Result
			if commnad_executor.is_available then
				resp := commnad_executor.location_in_view (a_session_id, an_id)
				check_response (resp)
				if not has_error then
					if attached resp.value as l_value and then attached {JSON_OBJECT} string_to_json (l_value) as l_json_object then
						if attached l_json_object.item ("x") as l_x then
							Result.set_x (l_x.representation.to_integer_32)
						end
						if attached l_json_object.item ("y") as l_y then
							Result.set_y (l_y.representation.to_integer_32)
						end
					end
				end
			end
		end

	element_size (a_session_id: STRING_32; an_id: STRING_32): SE_DIMENSION
			--	GET /session/:sessionId/element/:id/size
			--	Determine an element's size in pixels. The size will be returned as a JSON object with width and height properties.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--		:id - ID of the element to route the command to.
			--	Returns:
			--		{width:number, height:number} The width and height of the element, in pixels.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
			--		StaleElementReference - If the element referenced by :id is no longer attached to the page's DOM.
		local
			resp: SE_RESPONSE
		do
			create Result
			if commnad_executor.is_available then
				resp := commnad_executor.element_size (a_session_id, an_id)
				check_response (resp)
				if not has_error then
					if attached resp.value as l_value and then attached {JSON_OBJECT} string_to_json (l_value) as l_json_object then
						if attached l_json_object.item ("width") as l_width then
							Result.set_width (l_width.representation.to_natural)
						end
						if attached l_json_object.item ("height") as l_height then
							Result.set_height (l_height.representation.to_natural)
						end
					end
				end
			end
		end

	element_css_value (a_session_id: STRING_32; an_id: STRING_32; a_property_name: STRING_32): detachable STRING_32
			--	GET /session/:sessionId/element/:id/css/:propertyName
			--	Query the value of an element's computed CSS property. The CSS property to query should be specified using the CSS property name, not the JavaScript property name (e.g. background-color instead of backgroundColor).
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--		:id - ID of the element to route the command to.
			--	Returns:
			--		{string} The value of the specified CSS property.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
			--		StaleElementReference - If the element referenced by :id is no longer attached to the page's DOM.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.element_css_value (a_session_id, an_id, a_property_name)
				check_response (resp)
				if not has_error then
					if attached resp.value as l_value then
						Result := l_value
					end
				end
			end
		end

	retrieve_browser_orientation (a_session_id: STRING_32): detachable STRING_32
			--	GET /session/:sessionId/orientation
			--	Get the current browser orientation. The server should return a valid orientation value as defined in ScreenOrientation: {LANDSCAPE|PORTRAIT}.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{string} The current browser orientation corresponding to a value defined in ScreenOrientation: {LANDSCAPE|PORTRAIT}.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.retrieve_browser_orientation (a_session_id)
				check_response (resp)
				if not has_error then
					if attached resp.value as l_value then
						Result := l_value
					end
				end
			end
				--ensure
				--	 if not has_error, has_valid_orientation (LANDSCAPE|PORTRAIT)
				-- not_has_error : not has_error implies has_valid_orientation ()
		end

	set_browser_orientation (a_session_id: STRING_32; orientation: STRING_32)
			--	POST /session/:sessionId/orientation
			--	Set the browser orientation. The orientation should be specified as defined in ScreenOrientation: {LANDSCAPE|PORTRAIT}.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		orientation - {string} The new browser orientation as defined in ScreenOrientation: {LANDSCAPE|PORTRAIT}.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		require
			valid_orientation: orientation.is_case_insensitive_equal ("LANDSCAPE") or else orientation.is_case_insensitive_equal ("PORTRAIT")
		local
			resp: SE_RESPONSE
			l_json: STRING_32
		do
			l_json := "[
				{"orientation" : "$orientation"}
			]"
			if commnad_executor.is_available then
				l_json.replace_substring_all ("$orientation", orientation)
				resp := commnad_executor.set_browser_orientation (a_session_id, l_json)
				check_response (resp)
			end
		end

	retrieve_alert_text (a_session_id: STRING_32): detachable STRING_32
			--	GET /session/:sessionId/alert_text
			--	Gets the text of the currently displayed JavaScript alert(), confirm(), or prompt() dialog.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{string} The text of the currently displayed alert.
			--	Potential Errors:
			--		NoAlertPresent - If there is no alert displayed.
		local
			resp: SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.retrieve_alert_text (a_session_id)
				check_response (resp)
				if not has_error then
					if attached resp.value as l_value then
						Result := l_value
					end
				end
			end
		end

	send_alert_text (a_session_id: STRING_32; text : STRING_32)
			--	POST /session/:sessionId/alert_text
			--	Sends keystrokes to a JavaScript prompt() dialog.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		text - {string} Keystrokes to send to the prompt() dialog.
			--	Potential Errors:
			--		NoAlertPresent - If there is no alert displayed.
		local
			resp : SE_RESPONSE
			l_json : STRING_32
		do
			 l_json := "[
			 { "text":"$text" }
			 ]"

			 if commnad_executor.is_available then
			 	l_json.replace_substring_all ("$text", text)
			 	resp := commnad_executor.send_alert_text (a_session_id, l_json)
			 	check_response (resp)
			 end
		end

	accept_alert (a_session_id: STRING_32)
			--	POST /session/:sessionId/accept_alert
			--	Accepts the currently displayed alert dialog. Usually, this is equivalent to clicking on the 'OK' button in the dialog.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Potential Errors:
			--		NoAlertPresent - If there is no alert displayed.
		local
			resp : SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp :=  commnad_executor.accept_alert (a_session_id)
				check_response (resp)
			end
		end

	dismiss_alert (a_session_id: STRING_32)
			--	POST /session/:sessionId/dismiss_alert
			--	Dismisses the currently displayed alert dialog. For confirm() and prompt() dialogs, this is equivalent to clicking the 'Cancel' button. For alert() dialogs, this is equivalent to clicking the 'OK' button.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Potential Errors:
			--		NoAlertPresent - If there is no alert displayed.
		local
			resp : SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp :=  commnad_executor.dismiss_alert (a_session_id)
				check_response (resp)
			end
		end

	move_to (a_session_id: STRING_32; web_element : WEB_ELEMENT; xoffset : NATURAL; yoffset:NATURAL)
			--	POST /session/:sessionId/moveto
			--	Move the mouse by an offset of the specificed element.
			--  If no element is specified, the move is relative to the current mouse cursor.
			--  If an element is provided but no offset, the mouse will be moved to the center of the element.
			--  If the element is not visible, it will be scrolled into view.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		element - {string} Opaque ID assigned to the element to move to, as described in the WebElement JSON Object. If not specified or is null, the offset is relative to current position of the mouse.
			--		xoffset - {number} X offset to move to, relative to the top-left corner of the element. If not specified, the mouse will move to the middle of the element.
			--		yoffset - {number} Y offset to move to, relative to the top-left corner of the element. If not specified, the mouse will move to the middle of the element.
		local
			resp : SE_RESPONSE
			l_json : STRING_32

		do
			l_json := "[
				{ "element" : "$element",
				  "yoffset" : $yoffset,
				  "xoffset" : $xoffset	
				}
			]"
			if commnad_executor.is_available then
				l_json.replace_substring_all ("$element", web_element.element)
				l_json.replace_substring_all ("$yoffset", yoffset.out)
				l_json.replace_substring_all ("$xoffset", xoffset.out)
				resp := commnad_executor.move_to (a_session_id, l_json)
				check_response (resp)
			end
		end

	click (a_session_id: STRING_32; button : SE_BUTTON )
			--	POST /session/:sessionId/click
			--	Click any mouse button (at the coordinates set by the last moveto command). Note that calling this command after calling buttondown and before calling button up (or any out-of-order interactions sequence) will yield undefined behaviour).
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		button - {number} Which button, enum: {LEFT = 0, MIDDLE = 1 , RIGHT = 2}. Defaults to the left mouse button if not specified.
		local
			resp : SE_RESPONSE
			l_json : STRING_32
		do
			l_json := "[
					{
					"button" : $number
				}
			]"
			if commnad_executor.is_available then
				l_json.replace_substring_all ("$number", button.value.out)
				resp := commnad_executor.click (a_session_id, l_json)
				check_response (resp)
			end
		end

	button_down (a_session_id: STRING_32; button : SE_BUTTON)
			--	POST /session/:sessionId/buttondown
			--	Click and hold the left mouse button (at the coordinates set by the last moveto command).
			--  Note that the next mouse-related command that should follow is buttonup .
			--  Any other mouse command (such as click or another call to buttondown) will yield undefined behaviour.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		button - {number} Which button, enum: {LEFT = 0, MIDDLE = 1 , RIGHT = 2}.
			--		Defaults to the left mouse button if not specified.
		local
			resp : SE_RESPONSE
			l_json : STRING_32
		do
			l_json := "[
					{
					"button" : $number
				}
			]"
			if commnad_executor.is_available then
				l_json.replace_substring_all ("$number", button.value.out)
				resp := commnad_executor.button_down (a_session_id, l_json)
				check_response (resp)
			end
		end

	button_up (a_session_id: STRING_32; button : SE_BUTTON)
			--	POST /session/:sessionId/buttonup
			--	Releases the mouse button previously held (where the mouse is currently at). Must be called once for every buttondown command issued. See the note in click and buttondown about implications of out-of-order commands.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		button - {number} Which button, enum: {LEFT = 0, MIDDLE = 1 , RIGHT = 2}.
			--		Defaults to the left mouse button if not specified.
		local
			resp : SE_RESPONSE
			l_json : STRING_32
		do
			l_json := "[
					{
					"button" : $number
				}
			]"
			if commnad_executor.is_available then
				l_json.replace_substring_all ("$number", button.value.out)
				resp := commnad_executor.button_up (a_session_id, l_json)
				check_response (resp)
			end
		end
	double_click (a_session_id: STRING_32)
			--	POST /session/:sessionId/doubleclick
			--	Double-clicks at the current mouse coordinates (set by moveto).
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
		local
			resp : SE_RESPONSE
		do
			if commnad_executor.is_available then
				resp := commnad_executor.double_click (a_session_id)
				check_response (resp)
			end
		end

	touch_click (a_session_id: STRING_32)
			--	POST /session/:sessionId/touch/click
			--	Single tap on the touch enabled device.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		element - {string} ID of the element to single tap on.
		do
		end

	touch_down (a_session_id: STRING_32)
			--	POST /session/:sessionId/touch/down
			--	Finger down on the screen.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		x - {number} X coordinate on the screen.
			--		y - {number} Y coordinate on the screen.
		do
		end

	touch_up (a_session_id: STRING_32)
			--	POST /session/:sessionId/touch/up
			--	Finger up on the screen.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		x - {number} X coordinate on the screen.
			--		y - {number} Y coordinate on the screen.
		do
		end

	touch_move (a_session_id: STRING_32)
			--	POST session/:sessionId/touch/move
			--	Finger move on the screen.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		x - {number} X coordinate on the screen.
			--		y - {number} Y coordinate on the screen.
		do
		end

	start_touch_scroll (a_session_id: STRING_32)
			--	POST session/:sessionId/touch/scroll
			--	Scroll on the touch screen using finger based motion events. Use this command to start scrolling at a particular screen location.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		element - {string} ID of the element where the scroll starts.
			--		xoffset - {number} The x offset in pixels to scroll by.
			--		yoffset - {number} The y offset in pixels to scroll by.
		do
		end

	touch_scroll (a_session: STRING_32)
			--	POST session/:sessionId/touch/scroll
			--	Scroll on the touch screen using finger based motion events. Use this command if you don't care where the scroll starts on the screen.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		xoffset - {number} The x offset in pixels to scrollby.
			--		yoffset - {number} The y offset in pixels to scrollby.
		do
		end

	touch_double_click (a_session_id: STRING_32)
			--	POST session/:sessionId/touch/doubleclick
			--	Double tap on the touch screen using finger motion events.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		element - {string} ID of the element to double tap on.
		do
		end

	touch_long_click (a_session_id: STRING_32)
			--	POST session/:sessionId/touch/longclick
			--	Long press on the touch screen using finger motion events.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		element - {string} ID of the element to long press on.
		do
		end

	start_touch_flick (a_session_id: STRING_32)
			--	POST session/:sessionId/touch/flick
			--	Flick on the touch screen using finger motion events. This flickcommand starts at a particulat screen location.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		element - {string} ID of the element where the flick starts.
			--		xoffset - {number} The x offset in pixels to flick by.
			--		yoffset - {number} The y offset in pixels to flick by.
			--		speed - {number} The speed in pixels per seconds.
		do
		end

	touch_flick (a_session_id: STRING_32)
			--	POST session/:sessionId/touch/flick
			--	Flick on the touch screen using finger motion events. Use this flick command if you don't care where the flick starts on the screen.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		xSpeed - {number} The x speed in pixels per second.
			--		ySpeed - {number} The y speed in pixels per second.
		do
		end

	retrieve_geo_location (a_session_id: STRING_32)
			--	GET /session/:sessionId/location
			--	Get the current geo location.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{latitude: number, longitude: number, altitude: number} The current geo location.
		do
		end

	set_geo_location (a_session_id: STRING_32)
			--	POST /session/:sessionId/location
			--	Set the current geo location.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		location - {latitude: number, longitude: number, altitude: number} The new location.
		do
		end

	retrieve_local_storage (a_session_id: STRING_32)
			--	GET /session/:sessionId/local_storage
			--	Get all keys of the storage.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{Array.<string>} The list of keys.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		do
		end

	set_location_storage (a_session_id: STRING_32)
			--	POST /session/:sessionId/local_storage
			--	Set the storage item for the given key.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		key - {string} The key to set.
			--		value - {string} The value to set.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		do
		end

	delete_local_storage (a_session_id: STRING_32)
			--	DELETE /session/:sessionId/local_storage
			--	Clear the storage.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		do
		end

	retrieve_storage_by_key (a_session_id: STRING_32; a_key: STRING_32)
			--	GET /session/:sessionId/local_storage/key/:key
			--	Get the storage item for the given key.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--		:key - The key to get.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		do
		end

	delete_storage_by_key (a_session_id: STRING_32; a_key: STRING_32)
			--	DELETE /session/:sessionId/local_storage/key/:key
			--	Remove the storage item for the given key.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--		:key - The key to remove.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		do
		end

	local_storage_size (a_session_id: STRING_32)
			--	GET /session/:sessionId/local_storage/size
			--	Get the number of items in the storage.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{number} The number of items in the storage.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		do
		end

	session_storage_keys (a_session_id: STRING_32)
			--	GET /session/:sessionId/session_storage
			--	Get all keys of the storage.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{Array.<string>} The list of keys.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		do
		end

	set_session_storage (a_session_id: STRING_32)
			--	POST /session/:sessionId/session_storage
			--	Set the storage item for the given key.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		key - {string} The key to set.
			--		value - {string} The value to set.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		do
		end

	delete_session_storage (a_session_id: STRING_32)
			--	DELETE /session/:sessionId/session_storage
			--	Clear the storage.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		do
		end

	retrive_storage_item_by_key (a_session_id: STRING_32; a_key: STRING_32)
			--	GET /session/:sessionId/session_storage/key/:key
			--	Get the storage item for the given key.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--		:key - The key to get.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		do
		end

	remove_storage_item_by_key (a_session_id: STRING_32; a_key: STRING_32)
			--	DELETE /session/:sessionId/session_storage/key/:key
			--	Remove the storage item for the given key.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--		:key - The key to remove.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		do
		end

	session_storage_size (a_session_id: STRING_32)
			--	GET /session/:sessionId/session_storage/size
			--	Get the number of items in the storage.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{number} The number of items in the storage.
			--	Potential Errors:
			--		NoSuchWindow - If the currently selected window has been closed.
		do
		end

	log (a_session_id: STRING_32)
			--	POST /session/:sessionId/log
			--	Get the log for a given log type. Log buffer is reset after each request.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	JSON Parameters:
			--		type - {string} The log type. This must be provided.
			--	Returns:
			--		{Array.<object>} The list of log entries.
		do
		end

	available_log_types (a_session_id: STRING_32)
			--	GET /session/:sessionId/log/types
			--	Get available log types.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{Array.<string>} The list of available log types.
		do
		end

	application_cache_status (a_session_id: STRING_32)
			--	GET /session/:sessionId/application_cache/status
			--	Get the status of the html5 application cache.
			--	URL Parameters:
			--		:sessionId - ID of the session to route the command to.
			--	Returns:
			--		{number} Status code for application cache: {UNCACHED = 0, IDLE = 1, CHECKING = 2, DOWNLOADING = 3, UPDATE_READY = 4, OBSOLETE = 5}
		do
		end

feature -- Error Handling

	check_response (a_response: SE_RESPONSE)
			-- Check the answer given from the selenium server. If the response status shows an error
			-- set has_error in True and let the description of the error in last_error
			-- in other case set has_error in False and last_error in Void
		do
			if a_response.status /= 0 then
					-- there was an error
				has_error := true
				last_error := error_handling (a_response.status)
			else
				has_error := false
				last_error := Void
			end
		end

feature {NONE} -- Implementation

	initialize_executor
		do
			create commnad_executor.make (host)
		end

	host: STRING_32

	desired_capabilities (capabilites: STRING_32): STRING_32
		do
			create Result.make_from_string (desired_capabilities_template)
			Result.replace_substring_all ("$DESIRED_CAPABILITIES", capabilites)
		end

	desired_capabilities_template: STRING = "[
					{
			 	  	 "desiredCapabilities": $DESIRED_CAPABILITIES
			 	  	}
		]"

	commnad_executor: COMMAND_EXECUTOR

	new_session (value: STRING_32; to: STRING_32): detachable SE_SESSION
		local
			l_rep: STRING_32
		do
			if to.is_case_insensitive_equal ("session") then
				if attached {JSON_OBJECT} string_to_json (value) as l_value then
					if attached l_value.item ("sessionId") as ls and then attached l_value.item ("value") as lv and then attached json_to_se_capabilities (lv.representation) as lc then
						l_rep := ls.representation
						l_rep.replace_substring_all ("%"", "")
						create Result.make (l_rep, lc)
					end
				end
			elseif to.is_case_insensitive_equal ("sessions") then
				if attached {JSON_OBJECT} string_to_json (value) as l_value then
					if attached l_value.item ("id") as ls and then attached l_value.item ("capabilities") as lv and then attached json_to_se_capabilities (lv.representation) as lc then
						l_rep := ls.representation
						l_rep.replace_substring_all ("%"", "")
						create Result.make (l_rep, lc)
					end
				end
			end
		end

	error_handling (a_code: INTEGER_32): SE_ERROR
			-- Inspect the code `a_code' and return the error
		do
			create Result.make (-1, "ErrorNotFound", "A9n unknown API error")
			inspect a_code
			when 6 then
				create Result.make (6, "NoSuchDriver", "A session is either terminated or not started")
			when 7 then
				create Result.make (7, "NoSuchDriver", "An element could not be located on the page using the given search parameters.")
			when 8 then
				create Result.make (8, "NoSuchDriver", "A request to switch to a frame could not be satisfied because the frame could not be found.")
			when 9 then
				create Result.make (9, "UnknownCommand", "The requested resource could not be found, or a request was received using an HTTP method that is not supported by the mapped resource.")
			when 10 then
				create Result.make (10, "StaleElementReference", "An element command failed because the referenced element is no longer attached to the DOM.")
			when 11 then
				create Result.make (11, "ElementNotVisible", "An element command could not be completed because the element is not visible on the page.")
			when 12 then
				create Result.make (12, "InvalidElementState", "An element command could not be completed because the element is in an invalid state (e.g. attempting to click a disabled element).")
			when 13 then
				create Result.make (13, "UnknownError", "An unknown server-side error occurred while processing the command.")
			when 15 then
				create Result.make (15, "ElementIsNotSelectable", "An attempt was made to select an element that cannot be selected.")
			when 17 then
				create Result.make (17, "JavaScriptError", "An error occurred while executing user supplied JavaScript.")
			when 19 then
				create Result.make (19, "XPathLookupError", "An error occurred while searching for an element by XPath.")
			when 21 then
				create Result.make (21, "Timeout", "An operation did not complete before its timeout expired.")
			when 23 then
				create Result.make (23, "NoSuchWindow", "A request to switch to a different window could not be satisfied because the window could not be found.")
			when 24 then
				create Result.make (24, "InvalidCookieDomain", "An illegal attempt was made to set a cookie under a different domain than the current page.")
			when 25 then
				create Result.make (25, "UnableToSetCookie", "A request to set a cookie's value could not be satisfied.")
			when 26 then
				create Result.make (26, "InvalidCookieDomain", "A modal dialog was open, blocking this operation")
			when 27 then
				create Result.make (27, "UnableToSetCookie", "An attempt was made to operate on a modal dialog when one was not open.")
			when 28 then
				create Result.make (28, "ScriptTimeout", "A script did not complete before its timeout expired.")
			when 29 then
				create Result.make (29, "InvalidElementCoordinates", "The coordinates provided to an interactions operation are invalid.")
			when 30 then
				create Result.make (30, "IMENotAvailable", "IME was not available.")
			when 31 then
				create Result.make (31, "IMEEngineActivationFailed", "An IME engine could not be started.")
			when 32 then
				create Result.make (32, "InvalidSelector", "Argument was an invalid selector (e.g. XPath/CSS).")
			when 33 then
				create Result.make (33, "SessionNotCreatedException", "A new session could not be created.")
			when 34 then
				create Result.make (34, "MoveTargetOutOfBounds", "Target provided for a move action is out of bounds.")
			end
		end

end
