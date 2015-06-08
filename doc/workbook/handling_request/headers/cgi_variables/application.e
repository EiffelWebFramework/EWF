note
	description : "Basic Service that shows the standard CGI variables"
	date        : "$Date$"
	revision    : "$Revision$"
	EIS: "name=CGI specification","src=(https://tools.ietf.org/html/rfc3875", "protocol=url"

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

					-- HTTP method
				l_page_response.replace_substring_all ("$http_method", req.request_method)
					-- URI
				l_page_response.replace_substring_all ("$uri", req.path_info)
					-- Protocol
				l_page_response.replace_substring_all ("$protocol", req.server_protocol)

					-- Fill the table rows with CGI standard variables
				create l_rows.make_empty

					-- Auth_type
				l_rows.append ("<tr>")
				l_rows.append ("<td>")
				l_rows.append ("AUTH_TYPE")
				l_rows.append ("</td>")
				l_rows.append ("<td>")
				if attached req.auth_type as l_type then
					l_rows.append (l_type)
				else
					l_rows.append ("Not present")
				end
				l_rows.append ("</td>")
				l_rows.append ("</tr>")


					-- Content length
				l_rows.append ("<tr>")
				l_rows.append ("<td>")
				l_rows.append ("CONTENT_LENGTH")
				l_rows.append ("</td>")
				l_rows.append ("<td>")
				if attached req.content_length as l_content_length then
					l_rows.append (l_content_length)
				else
					l_rows.append ("Not present")
				end
				l_rows.append ("</td>")
				l_rows.append ("</tr>")

					-- Content length
				l_rows.append ("<tr>")
				l_rows.append ("<td>")
				l_rows.append ("CONTENT_TYPE")
				l_rows.append ("</td>")
				l_rows.append ("<td>")
				if attached req.content_type as l_content_type then
					l_rows.append (l_content_type.string)
				else
					l_rows.append ("Not present")
				end
				l_rows.append ("</td>")
				l_rows.append ("</tr>")


					-- Gateway interface
				l_rows.append ("<tr>")
				l_rows.append ("<td>")
				l_rows.append ("GATEWAY_INTERFACE")
				l_rows.append ("</td>")
				l_rows.append ("<td>")
				if attached req.gateway_interface as l_gateway_interface then
					l_rows.append (l_gateway_interface)
				else
					l_rows.append ("Not present")
				end
				l_rows.append ("</td>")
				l_rows.append ("</tr>")


					-- Path info
				l_rows.append ("<tr>")
				l_rows.append ("<td>")
				l_rows.append ("PATH_INFO")
				l_rows.append ("</td>")
				l_rows.append ("<td>")
				if attached req.path_info as l_path_info then
					l_rows.append (l_path_info)
				else
					l_rows.append ("Not present")
				end
				l_rows.append ("</td>")
				l_rows.append ("</tr>")

					-- Path translated
				l_rows.append ("<tr>")
				l_rows.append ("<td>")
				l_rows.append ("PATH_TRANSLATED")
				l_rows.append ("</td>")
				l_rows.append ("<td>")
				if attached req.path_translated as l_path_translated then
					l_rows.append (l_path_translated)
				else
					l_rows.append ("Not present")
				end
				l_rows.append ("</td>")
				l_rows.append ("</tr>")

					-- Query string
				l_rows.append ("<tr>")
				l_rows.append ("<td>")
				l_rows.append ("QUERY_STRING")
				l_rows.append ("</td>")
				l_rows.append ("<td>")
				if attached req.query_string as l_query_string then
					l_rows.append (l_query_string)
				else
					l_rows.append ("Not present")
				end
				l_rows.append ("</td>")
				l_rows.append ("</tr>")

					-- Remote addr
				l_rows.append ("<tr>")
				l_rows.append ("<td>")
				l_rows.append ("REMOTE_ADDR")
				l_rows.append ("</td>")
				l_rows.append ("<td>")
				l_rows.append (req.remote_addr)
				l_rows.append ("</td>")
				l_rows.append ("</tr>")


					-- Remote host
				l_rows.append ("<tr>")
				l_rows.append ("<td>")
				l_rows.append ("REMOTE_HOST")
				l_rows.append ("</td>")
				l_rows.append ("<td>")
				if attached req.remote_host as l_remote_host then
					l_rows.append (l_remote_host)
				else
					l_rows.append ("Not present")
				end
				l_rows.append ("</td>")
				l_rows.append ("</tr>")



					-- Remote ident
				l_rows.append ("<tr>")
				l_rows.append ("<td>")
				l_rows.append ("REMOTE_IDENT")
				l_rows.append ("</td>")
				l_rows.append ("<td>")
				if attached req.remote_ident as l_remote_ident then
					l_rows.append (l_remote_ident)
				else
					l_rows.append ("Not present")
				end
				l_rows.append ("</td>")
				l_rows.append ("</tr>")


					-- Remote user
				l_rows.append ("<tr>")
				l_rows.append ("<td>")
				l_rows.append ("REMOTE_USER")
				l_rows.append ("</td>")
				l_rows.append ("<td>")
				if attached req.remote_user as l_remote_user then
					l_rows.append (l_remote_user)
				else
					l_rows.append ("Not present")
				end
				l_rows.append ("</td>")
				l_rows.append ("</tr>")


					-- Request method
				l_rows.append ("<tr>")
				l_rows.append ("<td>")
				l_rows.append ("REQUEST_METHOD")
				l_rows.append ("</td>")
				l_rows.append ("<td>")
				l_rows.append (req.request_method)
				l_rows.append ("</td>")
				l_rows.append ("</tr>")


					-- Script name
				l_rows.append ("<tr>")
				l_rows.append ("<td>")
				l_rows.append ("SCRIPT_NAME")
				l_rows.append ("</td>")
				l_rows.append ("<td>")
				l_rows.append (req.script_name)
				l_rows.append ("</td>")
				l_rows.append ("</tr>")

					-- Server name
				l_rows.append ("<tr>")
				l_rows.append ("<td>")
				l_rows.append ("SERVER_NAME")
				l_rows.append ("</td>")
				l_rows.append ("<td>")
				l_rows.append (req.server_name)
				l_rows.append ("</td>")
				l_rows.append ("</tr>")

					-- Server protocol
				l_rows.append ("<tr>")
				l_rows.append ("<td>")
				l_rows.append ("SERVER_PROTOCOL")
				l_rows.append ("</td>")
				l_rows.append ("<td>")
				l_rows.append (req.server_protocol)
				l_rows.append ("</td>")
				l_rows.append ("</tr>")

					-- Server software
				l_rows.append ("<tr>")
				l_rows.append ("<td>")
				l_rows.append ("SERVER_SOFTWARE")
				l_rows.append ("</td>")
				l_rows.append ("<td>")
				l_rows.append (req.server_software)
				l_rows.append ("</td>")
				l_rows.append ("</tr>")


				l_page_response.replace_substring_all ("$rows", l_rows)

					-- Reading the raw header
				if attached req.raw_header_data as l_raw_header then
					l_page_response.replace_substring_all ("$raw_header", l_raw_header)
				end
				res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", l_page_response.count.out]>>)
				res.put_string (l_page_response)
			end
		end



	html_template: STRING = "[
				<!DOCTYPE html>
				<html>
				<head>
					<style>
						thead {color:green;}
						tbody {color:blue;}
						table, th, td {
						    border: 1px solid black;
						}
					</style>
				</head>
				
				<body>
				    <h1>EWF service example: Showing Standard CGI Variables</h1>
				   
				    <strong>HTTP METHOD:</strong>$http_method<br>
				    <strong>URI:</strong>$uri<br>
				    <strong>PROTOCOL:</strong>$protocol<br>
				     
				    <br> 
					<table>
					   <thead>
					   <tr>
					        <th>CGI Name</th>
						    <th>Value</th>
					   </tr>
					   </thead>
					   <tbody>
					   $rows
					   </tbody>
					</table>
					
					
					<h2>Raw header</h2>
					
					$raw_header
				</body>
				</html>
			]"


end
