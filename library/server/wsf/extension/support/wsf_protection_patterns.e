note
	description: "[
		{WSF_PROTECTION_PATTERNS}
		Provide application security parterns to assist in Cross Site Scripting
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=OWASP XSS", "src=https://www.owasp.org/index.php/XSS_Filter_Evasion_Cheat_Sheet", "protocol=uri"
	EIS: "name=Regular expression protection", "src=https://docs.apigee.com/api-services/reference/regular-expression-protection", "protocol=uri"

expanded class
	WSF_PROTECTION_PATTERNS


feature -- xss PATTERNS

	XSS_regular_expression: REGULAR_EXPRESSION
		note
			EIS: "name= XSS", "src=https://community.apigee.com/questions/27198/xss-threat-protection-patterns.html#answer-27465", "protocol=uri"
		local
			p: STRING_32
		once
			p := "((\%%3C)|<)[^\n]+((\%%3E)|>)"
			Result := compiled_regexp (p, True)
		end

feature {NONE} -- Implementation

	compiled_regexp (p: STRING; caseless: BOOLEAN): REGULAR_EXPRESSION
		require
			p /= Void
		do
			create Result
			Result.set_caseless (caseless)
			Result.compile (p)
		ensure
			Result.is_compiled
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
