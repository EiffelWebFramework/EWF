note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	LIBCURL_HTTP_CLIENT_REQUEST

inherit
	HTTP_CLIENT_REQUEST
		rename
			make as make_request
		redefine
			session
		end

create
	make

feature {NONE} -- Initialization

	make (a_url: READABLE_STRING_8; a_request_method: like request_method; a_session: like session; ctx: like context)
		do
			make_request (a_url, a_session, ctx)
			request_method := a_request_method
		end

	session: LIBCURL_HTTP_CLIENT_SESSION

feature -- Access

	request_method: READABLE_STRING_8

feature -- Execution

	execute: HTTP_CLIENT_RESPONSE
		local
			l_result: INTEGER
			l_curl_string: CURL_STRING
			l_url: READABLE_STRING_8
			p: POINTER
			a_data: CELL [detachable ANY]
			l_form, l_last: CURL_FORM
			curl: CURL_EXTERNALS
			curl_easy: CURL_EASY_EXTERNALS
			curl_handle: POINTER
			ctx: like context
		do
			ctx := context
			curl := session.curl
			curl_easy := session.curl_easy

			l_url := url
			if ctx /= Void then
				if attached ctx.query_parameters as l_query_params then
					from
						l_query_params.start
					until
						l_query_params.after
					loop
						append_parameters_to_url (l_url, <<[l_query_params.key_for_iteration, urlencode (l_query_params.item_for_iteration)]>>)
						l_query_params.forth
					end
				end
			end

			--| Configure cURL session
			curl_handle := curl_easy.init

			--| URL
			curl_easy.setopt_string (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_url, l_url)

			--| RESPONSE HEADERS
			curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_header, 1)

			--| PROXY ...
			if ctx /= Void and then attached ctx.proxy as l_proxy then
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_proxyport, l_proxy.port)
				curl_easy.setopt_string (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_proxy, l_proxy.host)
			end

			--| Timeout
			if timeout > 0 then
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_timeout, timeout)
			end
			--| Connect Timeout
			if connect_timeout > 0 then
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_connecttimeout, timeout)
			end
			--| Redirection
			if max_redirects /= 0 then
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_followlocation, 1)
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_maxredirs, max_redirects)
			else
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_followlocation, 0)
			end

			if request_method.is_case_insensitive_equal ("GET") then
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_httpget, 1)
			elseif request_method.is_case_insensitive_equal ("POST") then
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_post, 1)
			elseif request_method.is_case_insensitive_equal ("PUT") then
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_put, 1)
			elseif request_method.is_case_insensitive_equal ("HEAD") then
				curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_nobody, 1)
			elseif request_method.is_case_insensitive_equal ("DELETE") then
				curl_easy.setopt_string (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_customrequest, "DELETE")
			else
				curl_easy.setopt_string (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_customrequest, request_method)
				--| ignored
			end

			--| Credential
			if ctx /= Void and then ctx.credentials_required then
				if attached credentials as l_credentials then
					inspect auth_type_id
					when {HTTP_CLIENT_CONSTANTS}.Auth_type_none then
						curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_httpauth, {CURL_OPT_CONSTANTS}.curlauth_none)
					when {HTTP_CLIENT_CONSTANTS}.Auth_type_basic then
						curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_httpauth, {CURL_OPT_CONSTANTS}.curlauth_basic)
					when {HTTP_CLIENT_CONSTANTS}.Auth_type_digest then
						curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_httpauth, {CURL_OPT_CONSTANTS}.curlauth_digest)
					when {HTTP_CLIENT_CONSTANTS}.Auth_type_any then
						curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_httpauth, {CURL_OPT_CONSTANTS}.curlauth_any)
					when {HTTP_CLIENT_CONSTANTS}.Auth_type_anysafe then
						curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_httpauth, {CURL_OPT_CONSTANTS}.curlauth_anysafe)
					else
					end

					curl_easy.setopt_string (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_userpwd, l_credentials)
				else
					--| Credentials not prov  ided ...
				end
			end

			if ctx /= Void and then ctx.has_form_data then
				if attached ctx.form_parameters as l_forms and then not l_forms.is_empty then
--					curl_easy.set_debug_function (curl_handle)
--					curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_verbose, 1)

					create l_form.make
					create l_last.make
					from
						l_forms.start
					until
						l_forms.after
					loop
						curl.formadd_string_string (l_form, l_last, {CURL_FORM_CONSTANTS}.CURLFORM_COPYNAME, l_forms.key_for_iteration, {CURL_FORM_CONSTANTS}.CURLFORM_COPYCONTENTS, l_forms.item_for_iteration, {CURL_FORM_CONSTANTS}.CURLFORM_END)
						l_forms.forth
					end
					l_last.release_item
					curl_easy.setopt_form (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_httppost, l_form)
				end
			end
			if ctx /= Void then
				if request_method.is_case_insensitive_equal ("POST") or request_method.is_case_insensitive_equal ("PUT") then
					if ctx.has_upload_data and then attached ctx.upload_data as l_upload_data then
						curl_easy.setopt_string (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_postfields, l_upload_data)
						curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_postfieldsize, l_upload_data.count)
					end
					if ctx.has_upload_filename and then attached ctx.upload_filename as l_upload_filename then
--						curl_easy.setopt_string (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_postfields, l_upload_data)
--						curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_postfieldsize, l_upload_data.count)
--| Not Yet Implemented
					end
				end
			end

			curl.global_init
			if attached headers as l_headers then
				across
					l_headers as curs
				loop
					p := curl.slist_append (p, curs.key + ": " + curs.item)
				end
			end
			p := curl.slist_append (p, "Expect:")
			curl_easy.setopt_slist (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_httpheader, p)

			curl.global_cleanup

			curl_easy.set_read_function (curl_handle)
			curl_easy.set_write_function (curl_handle)
			create l_curl_string.make_empty
			curl_easy.setopt_curl_string (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_writedata, l_curl_string)

			debug ("service")
				io.put_string ("SERVICE: " + l_url)
				io.put_new_line
			end

			create Result.make
			l_result := curl_easy.perform (curl_handle)

			if l_result = {CURL_CODES}.curle_ok then
				create a_data.put (Void)
				l_result := curl_easy.getinfo (curl_handle, {CURL_INFO_CONSTANTS}.curlinfo_response_code, a_data)
				if l_result = 0 and then attached {INTEGER} a_data.item as l_http_status then
					Result.status := l_http_status
				else
					Result.status := 0
				end

				set_header_and_body_to (l_curl_string.string, Result)
			else
				Result.set_error_occurred (True)
			end

			curl_easy.cleanup (curl_handle)
		end


	set_header_and_body_to (a_source: READABLE_STRING_8; res: HTTP_CLIENT_RESPONSE)
			-- Parse `a_source' response
			-- and set `header' and `body' from HTTP_CLIENT_RESPONSE `res'
		local
			pos, l_start : INTEGER
		do
			l_start := a_source.substring_index ("%R%N", 1)
			if l_start > 0 then
					--| Skip first line which is the status line
					--| ex: HTTP/1.1 200 OK%R%N
				l_start := l_start + 2
			end
			if l_start < a_source.count and then a_source[l_start] = '%R' and a_source[l_start + 1] = '%N' then
				res.set_body (a_source)
			else
				pos := a_source.substring_index ("%R%N%R%N", l_start)
				if pos > 0 then
					res.set_raw_header (a_source.substring (l_start, pos + 1)) --| Keep the last %R%N
					res.set_body (a_source.substring (pos + 4, a_source.count))
				else
					res.set_body (a_source)
				end
			end
		end
end
