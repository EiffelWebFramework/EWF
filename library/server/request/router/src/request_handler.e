note
	description: "Summary description for {REQUEST_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	REQUEST_HANDLER [C -> REQUEST_HANDLER_CONTEXT]

inherit
	ANY

	ROUTED_APPLICATION_HELPER
		export
			{NONE} all
		end

feature -- Status report

	is_valid_context (req: WGI_REQUEST): BOOLEAN
			-- Is `req' valid context for current handler?
		do
			Result := True
		end

feature -- Execution

	execute (ctx: C; req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
			-- Execute request handler	
		require
			is_valid_context: is_valid_context (req)
		deferred
		end

feature -- Execution: report

	url (req: WGI_REQUEST; a_base: detachable READABLE_STRING_8; args: detachable STRING; abs: BOOLEAN): STRING
			-- Associated url based on `a_base' and `args'
			-- if `abs' then return absolute url
		local
			s: detachable STRING
			l_base: STRING
		do
			if a_base /= Void then
				l_base := a_base
			else
				l_base := req.request_uri
			end
			s := args
			if s /= Void and then s.count > 0 then
				if s[1] /= '/' then
					s := l_base + "/" + s
				else
					s := l_base + s
				end
			else
				s := l_base
			end
			if abs then
				Result := req.absolute_script_url (s)
			else
				Result := req.script_url (s)
			end
		ensure
			result_attached: Result /= Void
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
