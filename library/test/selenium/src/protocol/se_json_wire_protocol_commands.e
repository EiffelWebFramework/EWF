note
	description: "Summary description for {SE_JSON_WIRE_PROTOCOL_COMMANDS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SE_JSON_WIRE_PROTOCOL_COMMANDS

feature

	cmd_ping: STRING = ""
			--GET	/ expected a 200 ok

	cmd_status: STRING = "status"
			--GET	/status	 Query the server's current status.

	cmd_new_session: STRING = "session"
			--POST	/session	 Create a new session.

	cmd_sessions: STRING = "sessions"
			--GET	/sessions	 Returns a list of the currently active sessions.

	cmd_session_by_id_tmpl: STRING = "session/$id"

	cmd_session_by_id (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_by_id_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_timeouts_tmpl: STRING_32 = "[
			session/$id/timeouts
		]"

	cmd_session_timeouts (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_timeouts_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_timeouts_async_script_tmpl: STRING = "session/$id/timeouts/async_script"

	cmd_session_timeouts_async_script (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_timeouts_async_script_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_timeouts_implicit_wait_tmpl: STRING = "session/$id/timeouts/implicit_wait"

	cmd_session_timeouts_implicit_wait (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_timeouts_implicit_wait_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_window_handle_tmpl: STRING = "session/$id/window_handle"

	cmd_session_window_handle (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_window_handle_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_window_handles_tmpl: STRING = "session/$id/window_handles"

	cmd_session_window_handles (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_window_handles_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_url_tmpl: STRING = "session/$id/url"

	cmd_session_url (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_url_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_forward_tmpl: STRING = "session/$id/forward"

	cmd_session_forward (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_forward_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_back_tmpl: STRING = "session/$id/back"

	cmd_session_back (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_back_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_refresh_tmpl: STRING = "session/$id/refresh"

	cmd_session_refresh (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_refresh_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_execute_tmpl: STRING = "session/$id/execute"

	cmd_session_execute (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_execute_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_execute_async_tmpl: STRING = "session/$id/execute_async"

	cmd_session_execute_async (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_execute_async_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_screenshot_tmpl: STRING = "session/$id/screenshot"

	cmd_session_screenshot (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_screenshot_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_ime_available_engines_tmpl: STRING = "session/$id/ime/available_engines"

	cmd_session_ime_available (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_ime_available_engines_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_ime_active_engine_tmpl: STRING = "session/$id/ime/active_engine"

	cmd_session_ime_active_engine (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_ime_active_engine_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_ime_activated_tmpl: STRING = "session/$id/ime/activated"

	cmd_session_ime_activated (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_ime_activated_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_ime_deactivate_tmpl: STRING = "session/$id/ime/deactivate"

	cmd_session_ime_deactivate (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_ime_deactivate_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_ime_activate_tmpl: STRING = "session/$id/ime/activate"

	cmd_session_ime_activate (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_ime_activate_tmpl)
			Result.replace_substring_all ("$id", id)
		end

		--POST	/session/:sessionId/frame	 Change focus to another frame on the page.

	cmd_session_frame_tmpl: STRING = "session/$id/frame"

	cmd_session_frame (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_frame_tmpl)
			Result.replace_substring_all ("$id", id)
		end


	cmd_session_window_tmpl: STRING = "session/$id/window"

	cmd_session_window (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_window_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_window_size_tmpl: STRING = "session/$id/window/$windowHandle/size"

	cmd_session_window_size (id: STRING_32; window_handle: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_window_size_tmpl)
			Result.replace_substring_all ("$id", id)
			Result.replace_substring_all ("$windowHandle", window_handle)
		end

	cmd_session_window_position_tmpl: STRING = "session/$id/window/$windowHandle/position"

	cmd_session_window_position (id: STRING_32; window_handle: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_window_position_tmpl)
			Result.replace_substring_all ("$id", id)
			Result.replace_substring_all ("$windowHandle", window_handle)
		end

	cmd_session_window_maximize_tmpl: STRING = "session/$id/window/$windowHandle/maximize"

	cmd_session_window_maximize (id: STRING_32; window_handle: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_window_maximize_tmpl)
			Result.replace_substring_all ("$id", id)
			Result.replace_substring_all ("$windowHandle", window_handle)
		end

	cmd_session_cookie_tmpl: STRING = "session/$id/cookie"

	cmd_session_cookie (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_cookie_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_cookie_delte_tmpl: STRING = "session/$id/cookie/$name"

	cmd_session_cookie_delete (id: STRING_32; name: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_cookie_delte_tmpl)
			Result.replace_substring_all ("$id", id)
			Result.replace_substring_all ("$name", name)
		end

	cmd_session_source_tmpl: STRING = "session/$id/source"

	cmd_session_source (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_source_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_title_tmpl: STRING = "session/$id/title"

	cmd_session_title (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_title_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_element_tmpl: STRING = "session/$id/element"

	cmd_session_element (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_element_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_elements_tmpl: STRING = "session/$id/elements"

	cmd_session_elements (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_elements_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_element_active_tmpl: STRING = "session/$id/element/active"

	cmd_session_element_active (id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_element_active_tmpl)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_element_id_tmpl: STRING = "session/$sessionId/element/$id"

	cmd_session_element_id (sessionId: STRING_32; id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_element_id_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
			Result.replace_substring_all ("$id", id)
		end

		--GET		/session/:sessionId/element/:id	 Describe the identified element.

	cmd_session_element_id_element_tmpl: STRING = "session/$sessionId/element/$id/element"

	cmd_session_element_id_element (sessionId: STRING_32; id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_element_id_element_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_element_id_elements_tmpl: STRING = "session/$sessionId/element/$id/elements"

	cmd_session_element_id_elements (sessionId: STRING_32; id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_element_id_elements_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_element_click_tmpl: STRING = "session/$sessionId/element/$id/click"

	cmd_session_element_click (sessionId: STRING_32; id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_element_click_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_element_submit_tmpl: STRING = "session/$sessionId/element/$id/submit"

	cmd_session_element_submit (sessionId: STRING_32; id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_element_submit_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_element_text_tmpl: STRING = "session/$sessionId/element/$id/text"

	cmd_session_element_text (sessionId: STRING_32; id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_element_text_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_element_event_tmpl: STRING = "session/$sessionId/element/$id/value"

	cmd_session_element_event (sessionId: STRING_32; id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_element_event_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_keys_tmpl: STRING = "session/$sessionId/keys"

	cmd_session_keys (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_keys_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_element_name_tmpl: STRING = "session/$sessionId/element/$id/name"

	cmd_session_element_name (sessionId: STRING_32; id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_element_name_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_element_clear_tmpl: STRING = "session/$sessionId/element/$id/clear"

	cmd_session_element_clear (sessionId: STRING_32; id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_element_name_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_element_selected_tmpl: STRING = "session/$sessionId/element/$id/selected"

	cmd_session_element_selected (sessionId: STRING_32; id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_element_selected_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_element_enabled_tmpl: STRING = "session/$sessionId/element/$id/enabled"

	cmd_session_element_enabled (sessionId: STRING_32; id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_element_enabled_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_element_attribute_name_tmpl: STRING = "session/$sessionId/element/$id/attribute/$name"

	cmd_session_element_attribute_name (sessionId: STRING_32; id: STRING_32; name: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_element_attribute_name_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
			Result.replace_substring_all ("$id", id)
			Result.replace_substring_all ("$name", name)
		end

	cmd_session_element_equals_tmpl: STRING = "session/$sessionId/element/$id/equals/$other"

	cmd_session_element_equals (sessionId: STRING_32; id: STRING_32; other: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_element_equals_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
			Result.replace_substring_all ("$id", id)
			Result.replace_substring_all ("$other", other)
		end

	cmd_session_element_displayed_tmpl: STRING = "session/$sessionId/element/$id/displayed"

	cmd_session_element_displayed (sessionId: STRING_32; id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_element_displayed_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_element_location_tmpl: STRING = "session/$sessionId/element/$id/location"

	cmd_session_element_location (sessionId: STRING_32; id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_element_location_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_element_location_in_view_tmpl: STRING = "session/$sessionId/element/$id/location_in_view"

	cmd_session_element_location_in_view (sessionId: STRING_32; id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_element_location_in_view_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_element_size_tmpl: STRING = "session/$sessionId/element/$id/size"

	cmd_session_element_size (sessionId: STRING_32; id: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_element_size_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
			Result.replace_substring_all ("$id", id)
		end

	cmd_session_element_css_value_tmpl: STRING = "session/$sessionId/element/$id/css/$propertyName"

	cmd_session_element_css_value (sessionId: STRING_32; id: STRING_32; property_name: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_element_css_value_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
			Result.replace_substring_all ("$id", id)
			Result.replace_substring_all ("$propertyName", property_name)
		end

	cmd_session_browser_orientation_tmpl: STRING = "session/$sessionId/orientation"

	cmd_session_browser_orientation (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_browser_orientation_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_alert_text_tmpl: STRING = "session/$sessionId/alert_text"

	cmd_session_alert_text (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_alert_text_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_accept_alert_tmpl: STRING = "session/$sessionId/accept_alert"

	cmd_session_accept_alert (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_accept_alert_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_dismiss_alert_tmpl: STRING = "session/$sessionId/dismiss_alert"

	cmd_session_dismiss_alert (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_dismiss_alert_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_move_to_tmpl: STRING = "session/$sessionId/move_to"

	cmd_session_move_to (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_move_to_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_click_tmpl: STRING = "session/$sessionId/click"

	cmd_session_click (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_click_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_buttondown_tmpl: STRING = "session/$sessionId/buttondown"

	cmd_session_buttondown (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_buttondown_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_buttonup_tmpl: STRING = "session/$sessionId/buttonup"

	cmd_session_buttonup (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_buttonup_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_doubleclick_tmpl: STRING = "session/$sessionId/doubleclick"

	cmd_session_double_click (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_doubleclick_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_touch_click_tmpl: STRING = "session/$sessionId/touch/click"

	cmd_session_touch_click (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_touch_click_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_touch_down_tmpl: STRING = "session/$sessionId/touch/down"

	cmd_session_touch_down (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_touch_down_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_touch_up_tmpl: STRING = "session/$sessionId/touch/up"

	cmd_session_touch_up (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_touch_up_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_touch_move_tmpl: STRING = "session/$sessionId/touch/move"

	cmd_session_touch_move (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_touch_move_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_touch_scroll_tmpl: STRING = "session/$sessionId/touch/scroll"

	cmd_session_touch_scroll (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_touch_scroll_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_touch_double_click_tmpl: STRING = "session/$sessionId/touch/doubleclick"

	cmd_session_touch_double_click (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_touch_double_click_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_touch_long_click_tmpl: STRING = "session/$sessionId/touch/longclick"

	cmd_session_touch_long_click (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_touch_long_click_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_touch_flick_tmpl: STRING = "session/$sessionId/touch/flick"

	cmd_session_touch_flick (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_touch_flick_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_geo_location_tmpl: STRING = "session/$sessionId/location"

	cmd_session_geo_location (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_geo_location_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_local_storage_tmpl: STRING = "session/$sessionId/local_storage"

	cmd_session_local_storage (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_local_storage_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_local_storage_key_tmpl: STRING = "session/$sessionId/local_storage/key/$key"

	cmd_session_local_storage_key (sessionId: STRING_32; key : STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_local_storage_key_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
			Result.replace_substring_all ("$key", key)
		end

	cmd_session_local_storage_size_tmpl: STRING = "session/$sessionId/local_storage/size"

	cmd_session_local_storage_size (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_local_storage_size_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_storage_tmpl: STRING = "session/$sessionId/session_storage"

	cmd_session_storage (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_storage_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_storage_key_tmpl: STRING = "session/$sessionId/session_storage/key/$key"

	cmd_session_storage_key (sessionId: STRING_32; key : STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_storage_key_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
			Result.replace_substring_all ("$key", key)
		end

	cmd_session_storage_size_tmpl: STRING = "session/$sessionId/session_storage/size"

	cmd_session_storage_size (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_storage_size_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_log_tmpl: STRING = "session/$sessionId/log"

	cmd_session_log (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_log_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_log_types_tmpl: STRING = "session/$sessionId/log/types"

	cmd_session_log_types (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_log_types_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

	cmd_session_application_cache_tmpl: STRING = "session/$sessionId/application_cache/status"

	cmd_session_application_cache (sessionId: STRING_32): STRING_32
		do
			create Result.make_from_string (cmd_session_application_cache_tmpl)
			Result.replace_substring_all ("$sessionId", sessionId)
		end

end
