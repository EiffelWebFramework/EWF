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

		cmd_session_timeouts_implicit_wait_tmpl : STRING ="/session/$id/timeouts/implicit_wait"

		cmd_session_timeouts_implicit_wait (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_timeouts_implicit_wait_tmpl)
				Result.replace_substring_all ("$id", id)
			end


		cmd_session_window_handle_tmpl : STRING ="/session/$id/window_handle"

		cmd_session_window_handle (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_window_handle_tmpl)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_window_handles_tmpl : STRING ="/session/$id/window_handles"

		cmd_session_window_handles (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_window_handles_tmpl)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_url_tmpl : STRING ="/session/$id/url"

		cmd_session_url (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_url_tmpl)
				Result.replace_substring_all ("$id", id)
			end



		cmd_session_forward_tmpl : STRING ="/session/$id/forward"

		cmd_session_forward (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_forward_tmpl)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_back_tmpl : STRING ="/session/$id/back"

		cmd_session_back (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_back_tmpl)
				Result.replace_substring_all ("$id", id)
			end


		cmd_session_refresh_tmpl : STRING ="/session/$id/refresh"

		cmd_session_refresh (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_refresh_tmpl)
				Result.replace_substring_all ("$id", id)
			end


--POST	/session/:sessionId/execute	 Inject a snippet of JavaScript into the page for execution in the context of the currently selected frame.
--POST	/session/:sessionId/execute_async	 Inject a snippet of JavaScript into the page for execution in the context of the currently selected frame.


		cmd_session_screenshot_tmpl : STRING ="/session/$id/screenshot"

		cmd_session_screenshot (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_screenshot_tmpl)
				Result.replace_substring_all ("$id", id)
			end


		cmd_session_ime_available_engines_tmpl : STRING ="/session/$id/ime/available_engines"

		cmd_session_ime_available (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_ime_available_engines_tmpl)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_ime_active_engine_tmpl : STRING ="/session/$id/ime/active_engine"

		cmd_session_ime_active_engine (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_ime_active_engine_tmpl)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_ime_activated_tmpl : STRING ="/session/$id/ime/activated"

		cmd_session_ime_activated (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_ime_activated_tmpl)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_ime_deactivate_tmpl : STRING ="/session/$id/ime/deactivate"

		cmd_session_ime_deactivate (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_ime_deactivate_tmpl)
				Result.replace_substring_all ("$id", id)
			end

		cmd_session_ime_activate_tmpl : STRING ="/session/$id/ime/activate"

		cmd_session_ime_activate (id: STRING_32): STRING_32
			do
				create Result.make_from_string (cmd_session_ime_activate_tmpl)
				Result.replace_substring_all ("$id", id)
			end



--POST	/session/:sessionId/ime/activate	 Make an engines that is available (appears on the listreturned by getAvailableEngines) active.
--POST	/session/:sessionId/frame	 Change focus to another frame on the page.
--POST	/session/:sessionId/window	 Change focus to another window.
--DELETE	/session/:sessionId/window	 Close the current window.
--POST	/session/:sessionId/window/:windowHandle/size	 Change the size of the specified window.
--GET		/session/:sessionId/window/:windowHandle/size	 Get the size of the specified window.
--POST	/session/:sessionId/window/:windowHandle/position	 Change the position of the specified window.
--GET		/session/:sessionId/window/:windowHandle/position	 Get the position of the specified window.
--POST	/session/:sessionId/window/:windowHandle/maximize	 Maximize the specified window if not already maximized.
--GET		/session/:sessionId/cookie	 Retrieve all cookies visible to the current page.
--POST	/session/:sessionId/cookie	 Set a cookie.
--DELETE	/session/:sessionId/cookie	 Delete all cookies visible to the current page.
--DELETE	/session/:sessionId/cookie/:name	 Delete the cookie with the given name.
--GET		/session/:sessionId/source	 Get the current page source.
--GET		/session/:sessionId/title	 Get the current page title.
--POST	/session/:sessionId/element	 Search for an element on the page, starting from the document root.
--POST	/session/:sessionId/elements	 Search for multiple elements on the page, starting from the document root.
--POST	/session/:sessionId/element/active	 Get the element on the page that currently has focus.
--GET		/session/:sessionId/element/:id	 Describe the identified element.
--POST	/session/:sessionId/element/:id/element	 Search for an element on the page, starting from the identified element.
--POST	/session/:sessionId/element/:id/elements	 Search for multiple elements on the page, starting from the identified element.
--POST	/session/:sessionId/element/:id/click	 Click on an element.
--POST	/session/:sessionId/element/:id/submit	 Submit a FORM element.
--GET		/session/:sessionId/element/:id/text	 Returns the visible text for the element.
--POST	/session/:sessionId/element/:id/value	 Send a sequence of key strokes to an element.
--POST	/session/:sessionId/keys	 Send a sequence of key strokes to the active element.
--GET		/session/:sessionId/element/:id/name	 Query for an element's tag name.
--POST	/session/:sessionId/element/:id/clear	 Clear a TEXTAREA or text INPUT element's value.
--GET		/session/:sessionId/element/:id/selected	 Determine if an OPTION element, or an INPUT element of type checkbox or radiobutton is currently selected.
--GET		/session/:sessionId/element/:id/enabled	 Determine if an element is currently enabled.
--GET		/session/:sessionId/element/:id/attribute/:name	 Get the value of an element's attribute.
--GET		/session/:sessionId/element/:id/equals/:other	 Test if two element IDs refer to the same DOM element.
--GET		/session/:sessionId/element/:id/displayed	 Determine if an element is currently displayed.
--GET		/session/:sessionId/element/:id/location	 Determine an element's location on the page.
--GET		/session/:sessionId/element/:id/location_in_view	 Determine an element's location on the screen once it has been scrolled into view.
--GET		/session/:sessionId/element/:id/size	 Determine an element's size in pixels.
--GET		/session/:sessionId/element/:id/css/:propertyName	 Query the value of an element's computed CSS property.
--GET		/session/:sessionId/orientation	 Get the current browser orientation.
--POST	/session/:sessionId/orientation	 Set the browser orientation.
--GET		/session/:sessionId/alert_text	 Gets the text of the currently displayed JavaScript alert(), confirm(), or prompt() dialog.
--POST	/session/:sessionId/alert_text	 Sends keystrokes to a JavaScript prompt() dialog.
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
