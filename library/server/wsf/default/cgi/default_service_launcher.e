note
	description: "[
			Component to launch the service using the default connector

			which is CGI for this class

			How-to:

				s: DEFAULT_SERVICE_LAUNCHER
				create s.make_and_launch (agent execute)

				execute (req: WSF_REQUEST; res: WSF_RESPONSE)
					do
						-- ...
					end
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	DEFAULT_SERVICE_LAUNCHER

inherit
	WSF_SERVICE

create
	make_and_launch

feature {NONE} -- Initialization

	make_and_launch (a_action: like action)
		local
			cgi: WGI_CGI_CONNECTOR
		do
			action := a_action
			create cgi.make (Current)
			cgi.launch
		end

	make_and_launch_with_options (a_action: like action; a_options: ARRAY [detachable TUPLE [name: READABLE_STRING_GENERAL; value: detachable ANY]])
		do
			make_and_launch (a_action)
		end

feature -- Execution

	action: PROCEDURE [ANY, TUPLE [WSF_REQUEST, WSF_RESPONSE]]
			-- Action to be executed on request incoming 
		
	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		do
			action.call ([req, res])
		end

note
	copyright: "2011-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
