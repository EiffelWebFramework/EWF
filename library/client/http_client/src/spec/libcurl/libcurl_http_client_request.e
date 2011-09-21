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

	make (a_url: READABLE_STRING_8; a_request_method: like request_method; a_session: like session)
		do
			make_request (a_url, a_session)
			request_method := a_request_method
		end

	session: LIBCURL_HTTP_CLIENT_SESSION

feature -- Access

	request_method: READABLE_STRING_8

feature -- Execution

	execute (ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT): HTTP_CLIENT_RESPONSE
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
		do
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
				if attached ctx.form_data_parameters as l_posts and then not l_posts.is_empty then
--					curl_easy.set_debug_function (curl_handle)
--					curl_easy.setopt_integer (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_verbose, 1)

					create l_form.make
					create l_last.make
					from
						l_posts.start
					until
						l_posts.after
					loop
						curl.formadd_string_string (l_form, l_last, {CURL_FORM_CONSTANTS}.CURLFORM_COPYNAME, l_posts.key_for_iteration, {CURL_FORM_CONSTANTS}.CURLFORM_COPYCONTENTS, l_posts.item_for_iteration, {CURL_FORM_CONSTANTS}.CURLFORM_END)
						l_posts.forth
					end
					l_last.release_item
					curl_easy.setopt_form (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_httppost, l_form)
				end
			end


			curl.global_init
			if attached headers as l_headers then
				across
					l_headers as curs
				loop
					p := curl.slist_append (p, curs.key + ": " + curs.item)
--					curl_easy.setopt_slist (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_httpheader, p)
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

			create a_data.put (Void)
			l_result := curl_easy.getinfo (curl_handle, {CURL_INFO_CONSTANTS}.curlinfo_response_code, a_data)
			if l_result = 0 and then attached {INTEGER} a_data.item as l_http_status then
				Result.status := l_http_status
			else
				Result.status := 0
			end

--			last_api_call := l_url
			curl_easy.cleanup (curl_handle)


			Result.body := l_curl_string.string
		end

end
