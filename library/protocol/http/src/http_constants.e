note
	description: "Summary description for {HTTP_CONSTANTS}."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	HTTP_CONSTANTS

feature -- Ports

	default_http_port: INTEGER = 80
	default_https_port: INTEGER = 443

feature -- Method

	method_get: STRING = "GET"
	method_post: STRING = "POST"
	method_put: STRING = "PUT"
	method_delete: STRING = "DELETE"
	method_head: STRING = "HEAD"
	method_download: STRING = "DOWNLOAD"

feature -- Content type

	octet_stream: STRING = "application/octet-stream"
			-- Octet stream content-type header
	multipart_form: STRING = "multipart/form-data"
			-- Starting chars of multipart form data content-type header
	form_encoded: STRING = "application/x-www-form-urlencoded"
			-- Starting chars of form url-encoded data content-type header
	xml_text: STRING = "text/xml"
			-- XML text content-type header
	html_text: STRING = "text/html"
			-- HTML text content-type header
	json_text: STRING = "text/json"
			-- JSON text content-type header
	json_app: STRING = "application/json"
			-- JSON application content-type header
	js_text: STRING = "text/javascript"
			-- Javascript text content-type header
	js_app: STRING = "application/javascript"
			-- JavaScript application content-type header
	plain_text: STRING = "text/plain"
			-- Plain text content-type header

feature -- Server

	http_version_1_0: STRING = "HTTP/1.0"
	http_version_1_1: STRING = "HTTP/1.1"
	http_host_header: STRING = "Host"
	http_authorization_header: STRING = "Authorization: "
	http_end_of_header_line: STRING = "%R%N"
	http_end_of_command: STRING = "%R%N%R%N"
	http_content_length: STRING = "Content-Length: "
	http_content_type: STRING = "Content-Type: "
	http_content_location: STRING = "Content-Location: "
	http_content_disposition: STRING = "Content-Disposition: "
	http_path_translated: STRING = "Path-Translated: "
	http_agent: STRING = "User-agent: "
	http_from: STRING = "From: "

feature -- Server: header

	header_host: STRING = "Host"
	header_authorization: STRING = "Authorization"
	header_content_length: STRING = "Content-Length"
	header_content_type: STRING = "Content-Type"
	header_content_location: STRING = "Content-Location"
	header_content_disposition: STRING = "Content-Disposition"
	header_cache_control: STRING = "Cache-Control"
	header_path_translated: STRING = "Path-Translated"
	header_agent: STRING = "User-Agent"
	header_referer: STRING = "Referer" -- Officially mispelled in std
	header_location: STRING = "Location"
	header_from: STRING = "From"
	header_status: STRING = "Status"
	header_multipart_tag_value_separator: CHARACTER = ';'

feature -- Misc

	http_status_ok: STRING = "200 OK"

	default_bufsize: INTEGER = 16384 --| 16K


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
