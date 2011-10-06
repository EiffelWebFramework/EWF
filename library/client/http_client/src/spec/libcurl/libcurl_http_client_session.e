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
		end

feature -- Basic operation

	get (a_path: READABLE_STRING_8; ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT): HTTP_CLIENT_RESPONSE
		local
			req: HTTP_CLIENT_REQUEST
		do
			create {LIBCURL_HTTP_CLIENT_REQUEST} req.make (base_url + a_path, "GET", Current)
			Result := execute_request (req, ctx)
		end

	head (a_path: READABLE_STRING_8; ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT): HTTP_CLIENT_RESPONSE
		local
			req: HTTP_CLIENT_REQUEST
		do
			create {LIBCURL_HTTP_CLIENT_REQUEST} req.make (base_url + a_path, "HEAD", Current)
			Result := execute_request (req, ctx)
		end

	post (a_path: READABLE_STRING_8; a_ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT; a_data: detachable READABLE_STRING_8): HTTP_CLIENT_RESPONSE
		local
			req: HTTP_CLIENT_REQUEST
			ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT
		do
			create {LIBCURL_HTTP_CLIENT_REQUEST} req.make (base_url + a_path, "POST", Current)
			ctx := a_ctx
			if a_data /= Void then
				if ctx = Void then
					create ctx.make
				end
				ctx.set_upload_data (a_data)
			end
			Result := execute_request (req, ctx)
		end

	put (a_path: READABLE_STRING_8; a_ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT; fn: detachable READABLE_STRING_8): HTTP_CLIENT_RESPONSE
		local
			req: HTTP_CLIENT_REQUEST
			ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT
		do
			create {LIBCURL_HTTP_CLIENT_REQUEST} req.make (base_url + a_path, "PUT", Current)
			ctx := a_ctx
			if fn /= Void then
				if ctx = Void then
					create ctx.make
				end
				ctx.set_upload_filename (fn)
			end
			Result := execute_request (req, ctx)
		end

	delete (a_path: READABLE_STRING_8; ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT): HTTP_CLIENT_RESPONSE
		local
			req: HTTP_CLIENT_REQUEST
		do
			create {LIBCURL_HTTP_CLIENT_REQUEST} req.make (base_url + a_path, "DELETE", Current)
			Result := execute_request (req, ctx)
		end

feature {NONE} -- Implementation

	execute_request (req: HTTP_CLIENT_REQUEST; ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT): HTTP_CLIENT_RESPONSE
		do
			if ctx /= Void then
				req.import (ctx)
			end
			Result := req.execute (ctx)
		end

feature {LIBCURL_HTTP_CLIENT_REQUEST} -- Curl implementation

	curl: CURL_EXTERNALS
			-- cURL externals

	curl_easy: CURL_EASY_EXTERNALS
			-- cURL easy externals


end
