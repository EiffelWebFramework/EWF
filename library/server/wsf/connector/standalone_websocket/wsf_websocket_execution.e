note
	description: "[
			Objects that ...
		]"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_WEBSOCKET_EXECUTION

inherit
	WSF_EXECUTION
		rename
			execute as http_execute
		end

	WEB_SOCKET_CONSTANTS

	REFACTORING_HELPER

	HTTPD_LOGGER_CONSTANTS

	WGI_STANDALONE_CONNECTOR_ACCESS

--create
--	make

feature -- Execution

	is_verbose: BOOLEAN

	is_websocket: BOOLEAN

	has_error: BOOLEAN

	log (m: READABLE_STRING_8; lev: INTEGER)
		do

		end

	http_execute
		local
			ws: WEB_SOCKET
		do
			has_error := False
			is_websocket := False
			create ws.make (request, response)
			ws.open_ws_handshake
			if ws.is_websocket then
				has_error := ws.has_error
				is_websocket := True
				on_open (ws)
				execute_websocket (ws)
			else
				execute
			end
		end

	execute_websocket (ws: WEB_SOCKET)
		require
			is_websocket: is_websocket
		local
			exit: BOOLEAN
			l_frame: detachable WEB_SOCKET_FRAME
			l_client_message: detachable READABLE_STRING_8
			l_utf: UTF_CONVERTER
		do
			from
					-- loop until ws is closed or has error.
			until
				 has_error or else exit
			loop
--				debug ("dbglog")
--					dbglog (generator + ".LOOP WS_REQUEST_HANDLER.process_request {...}")
--				end
				if ws.socket_is_ready_for_reading then
					l_frame := ws.next_frame
					if l_frame /= Void and then l_frame.is_valid then
						if attached l_frame.injected_control_frames as l_injections then
								-- Process injected control frames now.
								-- FIXME
							across
								l_injections as ic
							loop
								if ic.item.is_connection_close then
										-- FIXME: we should probably send this event .. after the `l_frame.parent' frame event.
									on_event (ws, ic.item.payload_data, ic.item.opcode)
                      				exit := True
                      			elseif ic.item.is_ping then
                      					-- FIXME reply only to the most recent ping ...
                      				on_event (ws, ic.item.payload_data, ic.item.opcode)
                      			else
                      				on_event (ws, ic.item.payload_data, ic.item.opcode)
								end
							end
						end

						l_client_message := l_frame.payload_data
						if l_client_message = Void then
							l_client_message := ""
						end

--						debug ("ws")
						if is_verbose then
							print("%NExecute: %N")
							print (" [opcode: "+ opcode_name (l_frame.opcode) +"]%N")
							if l_frame.is_text then
								print (" [client message: %""+ l_client_message +"%"]%N")
							elseif l_frame.is_binary then
								print (" [client binary message length: %""+ l_client_message.count.out +"%"]%N")
							end
							print (" [is_control: " + l_frame.is_control.out + "]%N")
							print (" [is_binary: " + l_frame.is_binary.out + "]%N")
							print (" [is_text: " + l_frame.is_text.out + "]%N")
						end

						if l_frame.is_connection_close then
							on_event (ws, l_client_message, l_frame.opcode)
                      		exit := True
						elseif l_frame.is_binary then
 							on_event (ws, l_client_message, l_frame.opcode)
 						elseif l_frame.is_text then
 							check is_valid_utf_8: l_utf.is_valid_utf_8_string_8 (l_client_message) end
 							on_event (ws, l_client_message, l_frame.opcode)
 						else
 							on_event (ws, l_client_message, l_frame.opcode)
 						end
 					else
--						debug ("ws")
						if is_verbose then
							print("%NExecute: %N")
							print (" [ERROR: invalid frame]%N")
							if l_frame /= Void and then attached l_frame.error as err then
								print (" [Code: "+ err.code.out +"]%N")
								print (" [Description: "+ err.description +"]%N")
							end
						end
						on_event (ws, "", connection_close_frame)
 						exit := True
					end
				else
					if is_verbose then
						log (generator + ".WAITING WS_REQUEST_HANDLER.process_request {..}", debug_level)
					end
				end
			end
		end

	execute
			-- Execute Current request,
			-- getting data from `request'
			-- and response to client via `response'.
		deferred
		end

feature -- Web Socket Interface

	on_event (ws: WEB_SOCKET; a_message: detachable READABLE_STRING_8; a_opcode: INTEGER)
			-- Called when a frame from the client has been receive
		local
			l_message: READABLE_STRING_8
		do
			debug ("ws")
				print ("%Non_event (conn, a_message, " + opcode_name (a_opcode) + ")%N")
			end
			if a_message = Void then
				create {STRING} l_message.make_empty
			else
				l_message := a_message
			end

			if a_opcode = Binary_frame then
				on_binary (ws, l_message)
			elseif a_opcode = Text_frame then
				on_text (ws, l_message)
			elseif a_opcode = Pong_frame then
				on_pong (ws, l_message)
			elseif a_opcode = Ping_frame then
				on_ping (ws, l_message)
			elseif a_opcode = Connection_close_frame then
				on_connection_close (ws, "")
			else
				on_unsupported (ws, l_message, a_opcode)
			end
		end

	on_open (ws: WEB_SOCKET)
			-- Called after handshake, indicates that a complete WebSocket connection has been established.
		deferred
		end

	on_binary (ws: WEB_SOCKET; a_message: READABLE_STRING_8)
		deferred
		end

	on_pong (ws: WEB_SOCKET; a_message: READABLE_STRING_8)
		do
				-- log ("Its a pong frame")
				-- at first we ignore  pong
				-- FIXME: provide better explanation			
		end

	on_ping (ws: WEB_SOCKET; a_message: READABLE_STRING_8)
		do
			ws.send (Pong_frame, a_message)
		end

	on_text (ws: WEB_SOCKET; a_message: READABLE_STRING_8)
		deferred
		end

	on_unsupported (ws: WEB_SOCKET; a_message: READABLE_STRING_8; a_opcode: INTEGER)
		do
				-- do nothing
			fixme ("implement on_unsupported")
		end

	on_connection_close (ws: WEB_SOCKET; a_message: detachable READABLE_STRING_8)
		do
			ws.send (Connection_close_frame, "")
		end

	on_close (ws: WEB_SOCKET)
			-- Called after the WebSocket connection is closed.
		deferred
		end


note
	copyright: "2011-2016, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
