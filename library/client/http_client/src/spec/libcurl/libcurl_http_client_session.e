note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	LIBCURL_HTTP_CLIENT_SESSION

inherit
	HTTP_CLIENT_SESSION

create
	make

feature {NONE} -- Initialization

	initialize
		do
			create curl -- cURL externals
			create curl_easy -- cURL easy externals
			curl_easy.set_curl_function (create {LIBCURL_DEFAULT_FUNCTION}.make)
		end

feature -- Basic operation

	get (a_path: READABLE_STRING_8; ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT): HTTP_CLIENT_RESPONSE
		local
			req: HTTP_CLIENT_REQUEST
		do
			create {LIBCURL_HTTP_CLIENT_REQUEST} req.make (base_url + a_path, "GET", Current, ctx)
			Result := req.execute
		end

	head (a_path: READABLE_STRING_8; ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT): HTTP_CLIENT_RESPONSE
		local
			req: HTTP_CLIENT_REQUEST
		do
			create {LIBCURL_HTTP_CLIENT_REQUEST} req.make (base_url + a_path, "HEAD", Current, ctx)
			Result := req.execute
		end

	post (a_path: READABLE_STRING_8; a_ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT; data: detachable READABLE_STRING_8): HTTP_CLIENT_RESPONSE
		do
			Result := post_multipart (a_path, a_ctx, data, Void)
		end

	post_file (a_path: READABLE_STRING_8; a_ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT; fn: detachable READABLE_STRING_8): HTTP_CLIENT_RESPONSE
		do
			Result := post_multipart (a_path, a_ctx, Void, fn)
		end

	post_multipart (a_path: READABLE_STRING_8; a_ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT; data: detachable READABLE_STRING_8; fn: detachable READABLE_STRING_8): HTTP_CLIENT_RESPONSE
		local
			req: HTTP_CLIENT_REQUEST
			ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT
		do
			ctx := a_ctx
			if data /= Void then
				if ctx = Void then
					create ctx.make
				end
				ctx.set_upload_data (data)
			end
			if fn /= Void then
				if ctx = Void then
					create ctx.make
				end
				ctx.set_upload_filename (fn)
			end
			create {LIBCURL_HTTP_CLIENT_REQUEST} req.make (base_url + a_path, "POST", Current, ctx)
			Result := req.execute
		end

	put (a_path: READABLE_STRING_8; a_ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT; data: detachable READABLE_STRING_8): HTTP_CLIENT_RESPONSE
		local
			req: HTTP_CLIENT_REQUEST
			ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT
		do
			ctx := a_ctx
			if data /= Void then
				if ctx = Void then
					create ctx.make
				end
				ctx.set_upload_data (data)
			end
			create {LIBCURL_HTTP_CLIENT_REQUEST} req.make (base_url + a_path, "PUT", Current, ctx)
			Result := req.execute
		end

	put_file (a_path: READABLE_STRING_8; a_ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT; fn: detachable READABLE_STRING_8): HTTP_CLIENT_RESPONSE
		local
			req: HTTP_CLIENT_REQUEST
			ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT
		do
			ctx := a_ctx
			if fn /= Void then
				if ctx = Void then
					create ctx.make
				end
				ctx.set_upload_filename (fn)
			end
			create {LIBCURL_HTTP_CLIENT_REQUEST} req.make (base_url + a_path, "PUT", Current, ctx)
			Result := req.execute
		end

	delete (a_path: READABLE_STRING_8; ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT): HTTP_CLIENT_RESPONSE
		local
			req: HTTP_CLIENT_REQUEST
		do
			create {LIBCURL_HTTP_CLIENT_REQUEST} req.make (base_url + a_path, "DELETE", Current, ctx)
			Result := req.execute
		end

feature {LIBCURL_HTTP_CLIENT_REQUEST} -- Curl implementation

	curl: CURL_EXTERNALS
			-- cURL externals

	curl_easy: CURL_EASY_EXTERNALS
			-- cURL easy externals


end
