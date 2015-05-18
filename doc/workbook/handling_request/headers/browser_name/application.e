note
	description : "Basic Service that Read a Request, a  "
	date        : "$Date$"
	revision    : "$Revision$"
	EIS: "name=Browser detection using user agent","src=https://developer.mozilla.org/en-US/docs/Browser_detection_using_the_user_agent", "protocol=url"

class
	APPLICATION

inherit
	WSF_DEFAULT_SERVICE
		redefine
			initialize
		end

create
	make_and_launch

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			set_service_option ("port", 9090)
			set_service_option ("verbose", true)
		end

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the incomming request
		local
			l_raw_data: STRING
			l_page_response: STRING
			l_rows: STRING
		do
			create l_page_response.make_from_string (html_template)
			if  req.path_info.same_string ("/") then

					-- retrieve the user-agent
				if attached req.http_user_agent as l_user_agent then
					l_page_response.replace_substring_all ("$user_agent", l_user_agent)
					l_page_response.replace_substring_all ("$browser", get_browser_name (l_user_agent))
				else
					l_page_response.replace_substring_all ("$user_agent", "[]")
					l_page_response.replace_substring_all ("$browser", "Unknown, the user-agent was not present.")
				end
				res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", l_page_response.count.out]>>)
				res.put_string (l_page_response)
			end
		end


feature -- Browser utility

	get_browser_name (a_user_agent: READABLE_STRING_8):READABLE_STRING_32
			--						Must contain	Must not contain	
			--	Firefox				Firefox/xyz		Seamonkey/xyz	
			--	Seamonkey			Seamonkey/xyz	 	
			--	Chrome				Chrome/xyz		Chromium/xyz	
			--	Chromium			Chromium/xyz	 	
			--	Safari				Safari/xyz		Chrome/xyz
			--										Chromium/xyz
			--	Opera				OPR/xyz [1]
			--						Opera/xyz [2]
			--	Internet Explorer	;MSIE xyz;	 	Internet Explorer doesn't put its name in the BrowserName/VersionNumber format

		do
			if
				a_user_agent.has_substring ("Firefox") and then
				not a_user_agent.has_substring ("Seamonkey")
			then
				Result := "Firefox"
			elseif a_user_agent.has_substring ("Seamonkey") then
				Result := "Seamonkey"
			elseif a_user_agent.has_substring ("Chrome") and then not a_user_agent.has_substring ("Chromium")then
				Result := "Chrome"
			elseif a_user_agent.has_substring ("Chromium") then
				Result := "Chromiun"
			elseif a_user_agent.has_substring ("Safari") and then not (a_user_agent.has_substring ("Chrome") or else a_user_agent.has_substring ("Chromium"))  then
				Result := "Safari"
			elseif a_user_agent.has_substring ("OPR") or else  a_user_agent.has_substring ("Opera") then
				Result := "Opera"
			elseif a_user_agent.has_substring ("MSIE") or else a_user_agent.has_substring ("Trident")then
				Result := "Internet Explorer"
 			else
				Result := "Unknown"
			end
		end


	html_template: STRING = "[
				<!DOCTYPE html>
				<html>
				<head>
				</head>
				
				<body>
				    <h1>EWF service example: Showing Browser Dectection Using User-Agent</h1> <br>
				    
				    <strong>User Agent:</strong> $user_agent <br>
				   
				    <h2>Enjoy using $browser </h2> 
				</body>
				</html>
			]"


end
