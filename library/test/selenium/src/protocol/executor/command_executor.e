note
	description: "{COMMAND_EXECUTOR} object that execute a command in the JSONWireProtocol"
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=SELINIUM", "protocol=uri", "src=https://code.google.com/p/selenium/wiki/JsonWireProtocol#Commands"

class
	COMMAND_EXECUTOR

inherit

	JSON_HELPER

	SE_JSON_WIRE_PROTOCOL_COMMANDS

	-- TODO
	-- clean and improve the code
	-- handle response from the server in a smart way

create
	make

feature -- Initialization

	make (a_host: STRING_32)
		local
			h: LIBCURL_HTTP_CLIENT
		do
			host := a_host
			create h.make
			http_session := h.new_session (a_host)
				--  http_session.set_timeout (5)
				--	http_session.set_is_debug (True)
				--	http_session.set_proxy ("127.0.0.1", 8888)
		end

feature -- Status Report

	is_available: BOOLEAN
			-- Is the Seleniun server up and running?
		do
			Result := http_session.is_available
		end

feature -- Commands

	status: SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_status)
			Result := new_response ("", resp)
		end

	new_session (capabilities: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			create Result.make_empty
			resp := execute_post (cmd_new_session, capabilities)
			if not (resp.status >= 400) then
				Result := new_response ("", resp)
			else
				Result := new_response ("", resp)
			end
		end

	sessions: SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_sessions)
			Result := new_response ("", resp)
		end

	retrieve_session (session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_by_id (session_id))
			Result := new_response (session_id, resp)
		end

	delete_session (session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_delete (cmd_session_by_id (session_id))
			Result := new_response (session_id, resp)
		end

	set_session_timeouts (a_session_id: STRING_32; a_data_timeout: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_timeouts (a_session_id), a_data_timeout)
			Result := new_response (a_session_id, resp)
		end

	set_session_timeouts_async_script (a_session_id: STRING_32; a_data_timeout: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_timeouts_async_script (a_session_id), a_data_timeout)
			Result := new_response (a_session_id, resp)
		end

	set_session_timeouts_implicit_wait (a_session_id: STRING_32; a_data_timeout: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_timeouts_implicit_wait (a_session_id), a_data_timeout)
			Result := new_response (a_session_id, resp)
		end

	retrieve_window_handle (session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_window_handle (session_id))
			Result := new_response (session_id, resp)
		end

	retrieve_window_handles (session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_window_handles (session_id))
			Result := new_response (session_id, resp)
		end

	retrieve_url (session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_url (session_id))
			Result := new_response (session_id, resp)
		end

	navigate_to_url (a_session_id: STRING_32; a_url: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_url (a_session_id), a_url)
			Result := new_response (a_session_id, resp)
		end

	forward (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_forward (a_session_id), Void)
			Result := new_response (a_session_id, resp)
		end

	back (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_back (a_session_id), Void)
			Result := new_response (a_session_id, resp)
		end

	refresh (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_refresh (a_session_id), Void)
			Result := new_response (a_session_id, resp)
		end

	execute (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_execute (a_session_id), data)
			Result := new_response (a_session_id, resp)
		end

	execute_async (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_execute_async (a_session_id), data)
			Result := new_response (a_session_id, resp)
		end

	screenshot (session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_screenshot (session_id))
			Result := new_response (session_id, resp)
		end

	ime_available_engines (session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_ime_available (session_id))
			Result := new_response (session_id, resp)
		end

	ime_active_engine (session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_ime_active_engine (session_id))
			Result := new_response (session_id, resp)
		end

	ime_activated (session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_ime_activated (session_id))
			Result := new_response (session_id, resp)
		end

	ime_deactivate (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_ime_deactivate (a_session_id), Void)
			Result := new_response (a_session_id, resp)
		end

	ime_activate (a_session_id: STRING_32; an_engine: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_ime_activate (a_session_id), an_engine)
			Result := new_response (a_session_id, resp)
		end

	frame (a_session_id: STRING_32; a_data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_frame (a_session_id), a_data)
			Result := new_response (a_session_id, resp)
		end

	change_focus_window (a_session_id: STRING_32; a_data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_window (a_session_id), a_data)
			Result := new_response (a_session_id, resp)
		end

	close_window (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_delete (cmd_session_window (a_session_id))
			Result := new_response (a_session_id, resp)
		end

	change_size_window (a_session_id: STRING_32; a_window_handle: STRING_32; a_data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_window_size (a_session_id, a_window_handle), a_data)
			Result := new_response (a_session_id, resp)
		end

	size_window (a_session_id: STRING_32; a_window_handle: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_window_size (a_session_id, a_window_handle))
			Result := new_response (a_session_id, resp)
		end

	change_window_position (a_session_id: STRING_32; a_window_handle: STRING_32; a_data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_window_position (a_session_id, a_window_handle), a_data)
			Result := new_response (a_session_id, resp)
		end

	window_position (a_session_id: STRING_32; a_window_handle: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_window_size (a_session_id, a_window_handle))
			Result := new_response (a_session_id, resp)
		end

	window_maximize (a_session_id: STRING_32; a_window_handle: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_window_maximize (a_session_id, a_window_handle), Void)
			Result := new_response (a_session_id, resp)
		end

	retrieve_cookies (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_cookie (a_session_id))
			Result := new_response (a_session_id, resp)
		end

	set_cookie (a_session_id: STRING_32; a_data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_cookie (a_session_id), a_data)
			Result := new_response (a_session_id, resp)
		end

	delete_cookies (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_delete (cmd_session_cookie (a_session_id))
			Result := new_response (a_session_id, resp)
		end

	delete_cookie_by_name (a_session_id: STRING_32; a_name: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_delete (cmd_session_cookie_delete (a_session_id, a_name))
			Result := new_response (a_session_id, resp)
		end

	page_source (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_source (a_session_id))
			Result := new_response (a_session_id, resp)
		end

	page_title (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_title (a_session_id))
			Result := new_response (a_session_id, resp)
		end

	search_element (a_session_id: STRING_32; a_data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_element (a_session_id), a_data)
			Result := new_response (a_session_id, resp)
		end

	search_element_id_element (a_session_id: STRING_32; id: STRING_32; a_data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_element_id_element (a_session_id, id), a_data)
			Result := new_response (a_session_id, resp)
		end

	search_elements (a_session_id: STRING_32; a_data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_elements (a_session_id), a_data)
			Result := new_response (a_session_id, resp)
		end

	element_active (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_element_active (a_session_id))
			Result := new_response (a_session_id, resp)
		end

	search_element_id_elements (a_session_id: STRING_32; id: STRING_32; a_data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_element_id_elements (a_session_id, id), a_data)
			Result := new_response (a_session_id, resp)
		end

	element_click (a_session_id: STRING_32; id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_element_click (a_session_id, id), Void)
			Result := new_response (a_session_id, resp)
		end

	element_submit (a_session_id: STRING_32; id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_element_submit (a_session_id, id), Void)
			Result := new_response (a_session_id, resp)
		end

	element_text (a_session_id: STRING_32; id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_element_text (a_session_id, id))
			Result := new_response (a_session_id, resp)
		end

	send_events (a_session_id: STRING_32; id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_element_event (a_session_id, id), data)
			Result := new_response (a_session_id, resp)
		end

	send_key_strokes (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_keys (a_session_id), data)
			Result := new_response (a_session_id, resp)
		end

	query_by_tag_name (a_session_id: STRING_32; id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_element_name (a_session_id, id))
			Result := new_response (a_session_id, resp)
		end

	clear_element (a_session_id: STRING_32; id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_element_clear (a_session_id, id), Void)
			Result := new_response (a_session_id, resp)
		end

	is_enabled (a_session_id: STRING_32; id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_element_enabled (a_session_id, id))
			Result := new_response (a_session_id, resp)
		end

	is_selected (a_session_id: STRING_32; id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_element_selected (a_session_id, id))
			Result := new_response (a_session_id, resp)
		end

	element_value (a_session_id: STRING_32; id: STRING_32; name: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_element_attribute_name (a_session_id, id, name))
			Result := new_response (a_session_id, resp)
		end

	element_equals (a_session_id: STRING_32; id: STRING_32; other: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_element_equals (a_session_id, id, other))
			Result := new_response (a_session_id, resp)
		end

	is_displayed (a_session_id: STRING_32; id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_element_displayed (a_session_id, id))
			Result := new_response (a_session_id, resp)
		end

	element_location (a_session_id: STRING_32; id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_element_location (a_session_id, id))
			Result := new_response (a_session_id, resp)
		end

	location_in_view (a_session_id: STRING_32; id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_element_location_in_view (a_session_id, id))
			Result := new_response (a_session_id, resp)
		end

	element_size (a_session_id: STRING_32; id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_element_size (a_session_id, id))
			Result := new_response (a_session_id, resp)
		end

	element_css_value (a_session_id: STRING_32; id: STRING_32; property_name: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_element_css_value (a_session_id, id, property_name))
			Result := new_response (a_session_id, resp)
		end

	retrieve_browser_orientation (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_browser_orientation (a_session_id))
			Result := new_response (a_session_id, resp)
		end

	set_browser_orientation (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_browser_orientation (a_session_id), data)
			Result := new_response (a_session_id, resp)
		end

	retrieve_alert_text (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_alert_text (a_session_id))
			Result := new_response (a_session_id, resp)
		end

	send_alert_text (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_alert_text (a_session_id), data)
			Result := new_response (a_session_id, resp)
		end

	accept_alert (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_accept_alert (a_session_id), Void)
			Result := new_response (a_session_id, resp)
		end

	dismiss_alert (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_dismiss_alert (a_session_id), Void)
			Result := new_response (a_session_id, resp)
		end

	move_to (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_move_to (a_session_id), data)
			Result := new_response (a_session_id, resp)
		end

	click (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_click (a_session_id), data)
			Result := new_response (a_session_id, resp)
		end

	button_down (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_buttondown (a_session_id), data)
			Result := new_response (a_session_id, resp)
		end

	button_up (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_buttonup (a_session_id), data)
			Result := new_response (a_session_id, resp)
		end

	double_click (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_double_click (a_session_id), Void)
			Result := new_response (a_session_id, resp)
		end

	touch_click (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_touch_click (a_session_id), data)
			Result := new_response (a_session_id, resp)
		end

	touch_down (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_touch_down (a_session_id), data)
			Result := new_response (a_session_id, resp)
		end

	touch_up (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_touch_up (a_session_id), data)
			Result := new_response (a_session_id, resp)
		end

	touch_move (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_touch_move (a_session_id), data)
			Result := new_response (a_session_id, resp)
		end

	start_touch_scroll (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_touch_scroll (a_session_id), data)
			Result := new_response (a_session_id, resp)
		end

	touch_scroll (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		do
			Result := start_touch_scroll (a_session_id, data)
		end

	touch_double_click (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_touch_double_click (a_session_id), data)
			Result := new_response (a_session_id, resp)
		end

	touch_long_click (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_touch_long_click (a_session_id), data)
			Result := new_response (a_session_id, resp)
		end

	start_touch_flick (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_touch_flick (a_session_id), data)
			Result := new_response (a_session_id, resp)
		end

	touch_flick (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		do
			Result := start_touch_flick (a_session_id, data)
		end

	retrieve_geo_location (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_geo_location (a_session_id))
			Result := new_response (a_session_id, resp)
		end

	set_geo_location (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_geo_location (a_session_id), data)
			Result := new_response (a_session_id, resp)
		end

	retrieve_local_storage (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_local_storage (a_session_id))
			Result := new_response (a_session_id, resp)
		end

	set_location_storage (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_local_storage (a_session_id), data)
			Result := new_response (a_session_id, resp)
		end

	delete_local_storage (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_delete (cmd_session_local_storage (a_session_id))
			Result := new_response (a_session_id, resp)
		end

	retrieve_storage_by_key (a_session_id: STRING_32; key: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_local_storage_key (a_session_id, key))
			Result := new_response (a_session_id, resp)
		end

	delete_storage_by_key (a_session_id: STRING_32; key: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_delete (cmd_session_local_storage_key (a_session_id, key))
			Result := new_response (a_session_id, resp)
		end

	local_storage_size (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_local_storage_size (a_session_id))
			Result := new_response (a_session_id, resp)
		end

	session_storage_keys (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_storage (a_session_id))
			Result := new_response (a_session_id, resp)
		end

	set_session_storage (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_storage (a_session_id), data)
			Result := new_response (a_session_id, resp)
		end

	delete_session_storage (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_delete (cmd_session_storage (a_session_id))
			Result := new_response (a_session_id, resp)
		end

	retrive_storage_item_by_key (a_session_id: STRING_32; key: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_storage_key (a_session_id, key))
			Result := new_response (a_session_id, resp)
		end

	remove_storage_item_by_key (a_session_id: STRING_32; key: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_delete (cmd_session_storage_key (a_session_id, key))
			Result := new_response (a_session_id, resp)
		end

	session_storage_size (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_storage_size (a_session_id))
			Result := new_response (a_session_id, resp)
		end

	log (a_session_id: STRING_32; data: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_post (cmd_session_log (a_session_id), data)
			Result := new_response (a_session_id, resp)
		end

	available_log_types (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_log_types (a_session_id))
			Result := new_response (a_session_id, resp)
		end

	application_cache_status (a_session_id: STRING_32): SE_RESPONSE
		require
			selinum_server_available: is_available
		local
			resp: HTTP_CLIENT_RESPONSE
		do
			resp := execute_get (cmd_session_application_cache (a_session_id))
			Result := new_response (a_session_id, resp)
		end

feature {NONE} -- Implementation

	execute_get (command_name: STRING_32): HTTP_CLIENT_RESPONSE
		do
			Result := http_session.get (command_name, context_executor)
		end

	execute_post (command_name: STRING_32; data: detachable READABLE_STRING_8): HTTP_CLIENT_RESPONSE
		do
			Result := http_session.post (command_name, context_executor, data)
		end

	execute_delete (command_name: STRING_32): HTTP_CLIENT_RESPONSE
		do
			Result := http_session.delete (command_name, context_executor)
		end

	new_response (a_session_id: STRING_32; resp: HTTP_CLIENT_RESPONSE): SE_RESPONSE
			-- Create a new Selenium Response based on  `resp' HTTP_RESPONSE
			-- todo improve it!!!
		do
			create Result.make_empty
			if resp.status = 204 then
				Result.set_status (0)
				Result.set_session_id (a_session_id)
			else
				if attached resp.body as l_body then
					if attached json_to_se_response (l_body) as l_response then
						Result := l_response
					end
					Result.set_json_response (l_body)
				end
			end
		end

	context_executor: HTTP_CLIENT_REQUEST_CONTEXT
			-- request context for each request
		do
			create Result.make
			Result.headers.put ("application/json;charset=UTF-8", "Content-Type")
			Result.headers.put ("application/json;charset=UTF-8", "Accept")
		end

	host: STRING_32

	http_session: HTTP_CLIENT_SESSION

	http_new_session (url: STRING_32): HTTP_CLIENT_SESSION
		local
			h: LIBCURL_HTTP_CLIENT
		do
			create h.make
			Result := h.new_session (url)
				--		Result.set_is_debug (True)
				--		Result.set_proxy ("127.0.0.1", 8888)
		end

end
