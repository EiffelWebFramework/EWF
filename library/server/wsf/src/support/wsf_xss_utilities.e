note
	description: "Return safe (XSS protection) data for WSF_REQUEST query and form paramters."
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_XSS_UTILITIES


	-- TODO  add header protection.
	
feature -- Query parameters

	safe_query_parameter (a_req: WSF_REQUEST; a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE
			-- Safe Query parameter for name `a_name'.
		local
			l_wsf_xss: WSF_XSS_PROTECTION_PATTERNS
			r: REGULAR_EXPRESSION
		do
			r := l_wsf_xss.XSS_regular_expression
			Result := a_req.query_parameter (a_name)
			if Result /= Void then
				if
					attached {WSF_STRING} Result as str and then
					r.is_compiled
				then
					r.match (str.value)
					if r.has_matched then
						create {WSF_STRING} Result.make (str.name, " ")
					end
				end
			end
		end

feature -- Form Parameters

	safe_form_parameter (a_req: WSF_REQUEST; a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE
			-- Safe Form parameter for name `a_name'.
		local
			l_wsf_xss: WSF_XSS_PROTECTION_PATTERNS
			r: REGULAR_EXPRESSION
		do
			r := l_wsf_xss.XSS_regular_expression
			Result := a_req.form_parameter (a_name)
			if Result /= Void then
				if
					attached {WSF_STRING} Result as str and then
					r.is_compiled
				then
					r.match (str.value)
					if r.has_matched then
						create {WSF_STRING} Result.make (str.name, " ")
					end
				end
			end
		end

note
	copyright: "2011-2017, Jocelyn Fiat, Javier Velilla, Olivier Ligot, Colin Adams, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
