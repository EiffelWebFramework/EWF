note
	description: "Logging filter."
	author: "Olivier Ligot"
	date: "$Date$"
	revision: "$Revision$"

class
	LOGGING_FILTER

inherit
	WSF_FILTER

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the filter
		local
			l_user_agent: STRING
			l_date: DATE_TIME
		do
			if attached req.http_user_agent as ua then
				l_user_agent := ua.as_string_8
			else
				l_user_agent := "-"
			end
			create l_date.make_now
			io.put_string ("[" + l_date.formatted_out (Date_time_format) + "] %"" + req.request_method + " " + req.request_uri
				+ " " + {HTTP_CONSTANTS}.http_version_1_1 + "%" " + res.status_code.out + " " + l_user_agent)
			io.put_new_line
			execute_next (req, res)
		end

feature -- Constants

	Date_time_format: STRING = "yyyy/[0]mm/[0]dd [0]hh:[0]mi:[0]ss.ff3"

note
	copyright: "2011-2012, Javier Velilla and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
