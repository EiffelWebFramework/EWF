note
	description: "Summary description for {SE_JSON_WIRE_PROTOCOL_COMMANDS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SE_JSON_WIRE_PROTOCOL_COMMANDS

feature

		cmd_ping : STRING = ""
			--GET	/ expected a 200 ok

		cmd_status : STRING = "status"
			--GET	/status	 Query the server's current status.

		cmd_new_session : STRING = "session"
			--POST	/session	 Create a new session.
		cmd_sessions : STRING = "sessions"
			--GET	/sessions	 Returns a list of the currently active sessions.

		cmd_session_by_id_tmpl : STRING ="session/$id"

		cmd_session_by_id (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_by_id_tmpl)
				Result.replace_substring_all ("$id", id)
			end


		cmd_session_timeouts_tmpl : STRING_32 ="[
						session/$id/timeouts
						]"

		cmd_session_timeouts (id: STRING_32):STRING_32
			do
				create Result.make_from_string (cmd_session_timeouts_tmpl)
				Result.replace_substring_all ("$id",id)
			end

		cmd_session_timeouts_async_script_tmpl : STRING ="session/$id/timeouts/async_script"

		cmd_session_timeouts_async_script (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_timeouts_async_script_tmpl)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_timeouts_implicit_wait_tmpl : STRING ="session/$id/timeouts/implicit_wait"

		cmd_session_timeouts_implicit_wait (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_timeouts_implicit_wait_tmpl)
				Result.replace_substring_all ("$id", id)
			end


		cmd_session_window_handle_tmpl : STRING ="session/$id/window_handle"

		cmd_session_window_handle (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_window_handle_tmpl)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_window_handles_tmpl : STRING ="session/$id/window_handles"

		cmd_session_window_handles (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_window_handles_tmpl)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_url_tmpl : STRING ="session/$id/url"

		cmd_session_url (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_url_tmpl)
				Result.replace_substring_all ("$id", id)
			end



		cmd_session_forward_tmpl : STRING ="session/$id/forward"

		cmd_session_forward (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_forward_tmpl)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_back_tmpl : STRING ="session/$id/back"

		cmd_session_back (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_back_tmpl)
				Result.replace_substring_all ("$id", id)
			end


		cmd_session_refresh_tmpl : STRING ="session/$id/refresh"

		cmd_session_refresh (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_refresh_tmpl)
				Result.replace_substring_all ("$id", id)
			end


--POST	/session/:sessionId/execute	 Inject a snippet of JavaScript into the page for execution in the context of the currently selected frame.
--POST	/session/:sessionId/execute_async	 Inject a snippet of JavaScript into the page for execution in the context of the currently selected frame.


		cmd_session_screenshot_tmpl : STRING ="session/$id/screenshot"

		cmd_session_screenshot (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_screenshot_tmpl)
				Result.replace_substring_all ("$id", id)
			end


		cmd_session_ime_available_engines_tmpl : STRING ="session/$id/ime/available_engines"

		cmd_session_ime_available (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_ime_available_engines_tmpl)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_ime_active_engine_tmpl : STRING ="session/$id/ime/active_engine"

		cmd_session_ime_active_engine (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_ime_active_engine_tmpl)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_ime_activated_tmpl : STRING ="session/$id/ime/activated"

		cmd_session_ime_activated (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_ime_activated_tmpl)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_ime_deactivate_tmpl : STRING ="session/$id/ime/deactivate"

		cmd_session_ime_deactivate (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_ime_deactivate_tmpl)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_ime_activate_tmpl : STRING ="session/$id/ime/activate"

		cmd_session_ime_activate (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_ime_activate_tmpl)
				Result.replace_substring_all ("$id", id)
			end



--POST	/session/:sessionId/frame	 Change focus to another frame on the page.

		cmd_session_window_tmpl : STRING ="session/$id/window"

		cmd_session_window (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_window_tmpl)
				Result.replace_substring_all ("$id", id)
			end


		cmd_session_window_size_tmpl : STRING ="session/$id/window/$windowHandle/size"

		cmd_session_window_size (id: STRING_32; window_handle: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_window_size_tmpl)
				Result.replace_substring_all ("$id", id)
				Result.replace_substring_all ("$windowHandle", window_handle)
			end

		cmd_session_window_position_tmpl : STRING ="session/$id/window/$windowHandle/position"

		cmd_session_window_position (id: STRING_32; window_handle: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_window_position_tmpl)
				Result.replace_substring_all ("$id", id)
				Result.replace_substring_all ("$windowHandle", window_handle)
			end

		cmd_session_window_maximize_tmpl : STRING ="session/$id/window/$windowHandle/maximize"

		cmd_session_window_maximize (id: STRING_32; window_handle: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_window_maximize_tmpl)
				Result.replace_substring_all ("$id", id)
				Result.replace_substring_all ("$windowHandle", window_handle)
			end



		cmd_session_cookie_tmpl : STRING ="session/$id/cookie"

		cmd_session_cookie (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_cookie_tmpl)
				Result.replace_substring_all ("$id", id)
			end


		cmd_session_cookie_delte_tmpl : STRING ="session/$id/cookie/$name"

		cmd_session_cookie_delete (id: STRING_32;name : STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_cookie_delte_tmpl)
				Result.replace_substring_all ("$id", id)
				Result.replace_substring_all ("$name", name)
			end

		cmd_session_source_tmpl : STRING ="session/$id/source"

		cmd_session_source (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_source_tmpl)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_title_tmpl : STRING ="session/$id/title"

		cmd_session_title (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_source_tmpl)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_element_tmpl : STRING ="session/$id/element"

		cmd_session_element (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_element_tmpl)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_elements_tmpl : STRING ="session/$id/elements"

		cmd_session_elements (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_elements_tmpl)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_element_active_tmpl : STRING ="session/$id/element/active"

		cmd_session_element_active (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_element_active_tmpl)
				Result.replace_substring_all ("$id", id)
			end


		cmd_session_element_id_tmpl : STRING ="session/$sessionId/element/$id"

		cmd_session_element_id (sessionId: STRING_32; id : STRING_32 ): STRING_32
			do
				create Result.make_from_string (cmd_session_element_id_tmpl)
				Result.replace_substring_all ("$sessionId", sessionId)
				Result.replace_substring_all ("$id", id)
			end


--GET		/session/:sessionId/element/:id	 Describe the identified element.

		cmd_session_element_id_element_tmpl : STRING ="session/$sessionId/element/$id/element"

		cmd_session_element_id_element (sessionId: STRING_32; id : STRING_32 ): STRING_32
			do
				create Result.make_from_string (cmd_session_element_id_element_tmpl)
				Result.replace_substring_all ("$sessionId", sessionId)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_element_id_elements_tmpl : STRING ="session/$sessionId/element/$id/elements"

		cmd_session_element_id_elements (sessionId: STRING_32; id : STRING_32 ): STRING_32
			do
				create Result.make_from_string (cmd_session_element_id_elements_tmpl)
				Result.replace_substring_all ("$sessionId", sessionId)
				Result.replace_substring_all ("$id", id)
			end


		cmd_session_element_click_tmpl : STRING ="session/$sessionId/element/$id/click"

		cmd_session_element_click (sessionId: STRING_32; id : STRING_32 ): STRING_32
			do
				create Result.make_from_string (cmd_session_element_click_tmpl)
				Result.replace_substring_all ("$sessionId", sessionId)
				Result.replace_substring_all ("$id", id)
			end


		cmd_session_element_submit_tmpl : STRING ="session/$sessionId/element/$id/submit"

		cmd_session_element_submit (sessionId: STRING_32; id : STRING_32 ): STRING_32
			do
				create Result.make_from_string (cmd_session_element_submit_tmpl)
				Result.replace_substring_all ("$sessionId", sessionId)
				Result.replace_substring_all ("$id", id)
			end



		cmd_session_element_text_tmpl : STRING ="session/$sessionId/element/$id/text"

		cmd_session_element_text (sessionId: STRING_32; id : STRING_32 ): STRING_32
			do
				create Result.make_from_string (cmd_session_element_text_tmpl)
				Result.replace_substring_all ("$sessionId", sessionId)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_element_event_tmpl : STRING ="session/$sessionId/element/$id/value"

		cmd_session_element_event (sessionId: STRING_32; id : STRING_32 ): STRING_32
			do
				create Result.make_from_string (cmd_session_element_event_tmpl)
				Result.replace_substring_all ("$sessionId", sessionId)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_keys_tmpl : STRING ="session/$sessionId/keys"

		cmd_session_keys (sessionId: STRING_32 ): STRING_32
			do
				create Result.make_from_string (cmd_session_keys_tmpl)
				Result.replace_substring_all ("$sessionId", sessionId)
			end

		cmd_session_element_name_tmpl : STRING ="session/$sessionId/element/$id/name"

		cmd_session_element_name (sessionId: STRING_32; id : STRING_32 ): STRING_32
			do
				create Result.make_from_string (cmd_session_element_name_tmpl)
				Result.replace_substring_all ("$sessionId", sessionId)
				Result.replace_substring_all ("$id", id)
			end


		cmd_session_element_clear_tmpl : STRING ="session/$sessionId/element/$id/clear"

		cmd_session_element_clear (sessionId: STRING_32; id : STRING_32 ): STRING_32
			do
				create Result.make_from_string (cmd_session_element_name_tmpl)
				Result.replace_substring_all ("$sessionId", sessionId)
				Result.replace_substring_all ("$id", id)
			end


		cmd_session_element_selected_tmpl : STRING ="session/$sessionId/element/$id/selected"

		cmd_session_element_selected (sessionId: STRING_32; id : STRING_32 ): STRING_32
			do
				create Result.make_from_string (cmd_session_element_selected_tmpl)
				Result.replace_substring_all ("$sessionId", sessionId)
				Result.replace_substring_all ("$id", id)
			end


		cmd_session_element_enabled_tmpl : STRING ="session/$sessionId/element/$id/enabled"

		cmd_session_element_enabled (sessionId: STRING_32; id : STRING_32 ): STRING_32
			do
				create Result.make_from_string (cmd_session_element_enabled_tmpl)
				Result.replace_substring_all ("$sessionId", sessionId)
				Result.replace_substring_all ("$id", id)
			end


		cmd_session_element_attribute_name_tmpl : STRING ="session/$sessionId/element/$id/attribute/$name"

		cmd_session_element_attribute_name (sessionId: STRING_32; id : STRING_32; name : STRING_32 ): STRING_32
			do
				create Result.make_from_string (cmd_session_element_attribute_name_tmpl)
				Result.replace_substring_all ("$sessionId", sessionId)
				Result.replace_substring_all ("$id", id)
				Result.replace_substring_all ("$name", name)
			end

		cmd_session_element_equals_tmpl : STRING ="session/$sessionId/element/$id/equals/$other"

		cmd_session_element_equals (sessionId: STRING_32; id : STRING_32; other : STRING_32 ): STRING_32
			do
				create Result.make_from_string (cmd_session_element_equals_tmpl)
				Result.replace_substring_all ("$sessionId", sessionId)
				Result.replace_substring_all ("$id", id)
				Result.replace_substring_all ("$other", other)
			end

		cmd_session_element_displayed_tmpl : STRING ="session/$sessionId/element/$id/displayed"

		cmd_session_element_displayed (sessionId: STRING_32; id : STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_element_displayed_tmpl)
				Result.replace_substring_all ("$sessionId", sessionId)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_element_location_tmpl : STRING ="session/$sessionId/element/$id/location"

		cmd_session_element_location (sessionId: STRING_32; id : STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_element_location_tmpl)
				Result.replace_substring_all ("$sessionId", sessionId)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_element_location_in_view_tmpl : STRING ="session/$sessionId/element/$id/location_in_view"

		cmd_session_element_location_in_view (sessionId: STRING_32; id : STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_element_location_in_view_tmpl)
				Result.replace_substring_all ("$sessionId", sessionId)
				Result.replace_substring_all ("$id", id)
			end


		cmd_session_element_size_tmpl : STRING ="session/$sessionId/element/$id/size"

		cmd_session_element_size (sessionId: STRING_32; id : STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_element_size_tmpl)
				Result.replace_substring_all ("$sessionId", sessionId)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_element_css_value_tmpl : STRING ="session/$sessionId/element/$id/css/$propertyName"

		cmd_session_element_css_value (sessionId: STRING_32; id : STRING_32; property_name : STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_element_css_value_tmpl)
				Result.replace_substring_all ("$sessionId", sessionId)
				Result.replace_substring_all ("$id", id)
				Result.replace_substring_all ("$propertyName", property_name)
			end

		cmd_session_browser_orientation_tmpl : STRING ="session/$sessionId/orientation"

		cmd_session_browser_orientation (sessionId: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_browser_orientation_tmpl)
				Result.replace_substring_all ("$sessionId", sessionId)
			end

		cmd_session_alert_text_tmpl : STRING ="session/$sessionId/alert_text"

		cmd_session_alert_text (sessionId: STRING_32): STRING_32
				do
					create Result.make_from_string (cmd_session_alert_text_tmpl)
					Result.replace_substring_all ("$sessionId", sessionId)
				end


--POST	/session/:sessionId/accept_alert	 Accepts the currently displayed alert dialog.
--POST	/session/:sessionId/dismiss_alert	 Dismisses the currently displayed alert dialog.
--POST	/session/:sessionId/moveto	 Move the mouse by an offset of the specificed element.
--POST	/session/:sessionId/click	 Click any mouse button (at the coordinates set by the last moveto command).
--POST	/session/:sessionId/buttondown	 Click and hold the left mouse button (at the coordinates set by the last moveto command).
--POST	/session/:sessionId/buttonup	 Releases the mouse button previously held (where the mouse is currently at).
--POST	/session/:sessionId/doubleclick	 Double-clicks at the current mouse coordinates (set by moveto).
--POST	/session/:sessionId/touch/click	 Single tap on the touch enabled device.
--POST	/session/:sessionId/touch/down	 Finger down on the screen.
--POST	/session/:sessionId/touch/up	 Finger up on the screen.
--POST	/session/:sessionId/touch/move	 Finger move on the screen.
--POST	/session/:sessionId/touch/scroll	 Scroll on the touch screen using finger based motion events.
--POST	/session/:sessionId/touch/scroll	 Scroll on the touch screen using finger based motion events.
--POST	/session/:sessionId/touch/doubleclick	 Double tap on the touch screen using finger motion events.
--POST	/session/:sessionId/touch/longclick	 Long press on the touch screen using finger motion events.
--POST	/session/:sessionId/touch/flick	 Flick on the touch screen using finger motion events.
--POST	/session/:sessionId/touch/flick	 Flick on the touch screen using finger motion events.
--GET		/session/:sessionId/location	 Get the current geo location.
--POST	/session/:sessionId/location	 Set the current geo location.
--GET		/session/:sessionId/local_storage	 Get all keys of the storage.
--POST	/session/:sessionId/local_storage	 Set the storage item for the given key.
--DELETE	/session/:sessionId/local_storage	 Clear the storage.
--GET		/session/:sessionId/local_storage/key/:key	 Get the storage item for the given key.
--DELETE	/session/:sessionId/local_storage/key/:key	 Remove the storage item for the given key.
--GET		/session/:sessionId/local_storage/size	 Get the number of items in the storage.
--GET		/session/:sessionId/session_storage	 Get all keys of the storage.
--POST	/session/:sessionId/session_storage	 Set the storage item for the given key.
--DELETE	/session/:sessionId/session_storage	 Clear the storage.
--GET		/session/:sessionId/session_storage/key/:key	 Get the storage item for the given key.
--DELETE	/session/:sessionId/session_storage/key/:key	 Remove the storage item for the given key.
--GET		/session/:sessionId/session_storage/size	 Get the number of items in the storage.
--POST	/session/:sessionId/log	 Get the log for a given log type.
--GET		/session/:sessionId/log/types	 Get available log types.
--GET		/session/:sessionId/application_cache/status	 Get the status of the html5 application cache.
end
