note
	description : "Basic Service that Read Request Headers"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION_EXECUTION

inherit
	WSF_EXECUTION

create
	make

feature -- Basic operations

	execute
			-- Execute the incomming request
		local
			l_raw_data: STRING
			l_page_response: STRING
			l_rows: STRING
		do
			create l_page_response.make_from_string (html_template)
			if  request.path_info.same_string ("/") then

					-- HTTP method
				l_page_response.replace_substring_all ("$http_method", request.request_method)
					-- URI
				l_page_response.replace_substring_all ("$uri", request.path_info)
					-- Protocol
				l_page_response.replace_substring_all ("$protocol", request.server_protocol)

					-- Fill the table rows with HTTP Headers
				create l_rows.make_empty
				across request.meta_variables as ic loop
					if ic.item.name.starts_with ("HTTP_") then
						l_rows.append ("<tr>")
						l_rows.append ("<td>")
						l_rows.append (ic.item.name)
						l_rows.append ("</td>")
						l_rows.append ("<td>")
						l_rows.append (ic.item.value)
						l_rows.append ("</td>")
						l_rows.append ("</tr>")
					end
				end

				l_page_response.replace_substring_all ("$rows", l_rows)

					-- Reading the raw header
				if attached request.raw_header_data as l_raw_header then
					l_page_response.replace_substring_all ("$raw_header", l_raw_header)
				end
				response.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", l_page_response.count.out]>>)
				response.put_string (l_page_response)
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
				    <h1>EWF service example: Showing Request Headers</h1>
				   
				    <strong>HTTP METHOD:</strong>$http_method<br>
				    <strong>URI:</strong>$uri<br>
				    <strong>PROTOCOL:</strong>$protocol<br>
				    <strong>REQUEST TIME:</strong>$time<br>
				     
				    <br> 
					<table>
					   <thead>
					   <tr>
					        <th>Header Name</th>
						    <th>Header Value</th>
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
