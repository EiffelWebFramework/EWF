note

	description: "[
						Policies for determing caching of responses.
						]"
	date: "$Date$"
	revision: "$Revision$"

deferred class WSF_CACHING_POLICY

feature -- Access

	age (req: WSF_REQUEST): NATURAL
			-- Maximum age in seconds before response to `req` is considered stale;
			-- This is used to generate a Cache-Control: max-age header.
			-- Return 0 to indicate already expired.
			-- Return (365 * 1440 = 1 year) to indicate never expires.
		require
			req_attached: req /= Void
		deferred
		ensure
			not_more_than_1_year: Result <= (365 * 1440).as_natural_32
		end

	shared_age (req: WSF_REQUEST): NATURAL
			-- Maximum age in seconds before response to `req` is considered stale in a shared cache;
			-- This is used to generate a Cache-Control: s-maxage header.
			-- If you wish to have different expiry ages for shared and provate caches, redefine this routine.
			-- Return 0 to indicate already expired.
			-- Return (365 * 1440 = 1 year) to indicate never expires.
		require
			req_attached: req /= Void
		do
			Result := age (req)
		ensure
			not_more_than_1_year: Result <= (365 * 1440).as_natural_32
		end

	http_1_0_age (req: WSF_REQUEST): NATURAL
			-- Maximum age in seconds before response to `req` is considered stale;
			-- This is used to generate an Expires header, which HTTP/1.0 caches understand.
			-- If you wish to generate a different age for HTTP/1.0 caches, then redefine this routine.
			-- Return 0 to indicate already expired.
			-- Return (365 * 1440 = 1 year) to indicate never expires. Note this will
			--  make a result cachecable that would not normally be cacheable (such as as response
			--  to a POST), unless overriden by cache-control headers, so be sure to check `req.request_method'.
		require
			req_attached: req /= Void
		do
			Result := age (req)
		ensure
			not_more_than_1_year: Result <= (365 * 1440).as_natural_32
		end

	is_freely_cacheable (req: WSF_REQUEST): BOOLEAN
			-- Should the response to `req' be freely cachable in shared caches?
			-- If `True', then a Cache-Control: public header will be generated.
		require
			req_attached: req /= Void
		deferred
		end

	is_transformable (req: WSF_REQUEST): BOOLEAN
			-- Should a non-transparent proxy be allowed to modify headers of response to `req`?
			-- The headers concerned are listed in http://www.w3.org/Protocols/rfc2616-sec14.html#sec14,9.
			-- If `False' then a Cache-Control: no-transorm header will be generated.
		require
			req_attached: req /= Void
		do
			-- We choose a conservative default. But most applications can
			--  redefine to return `True'.
		end

	must_revalidate (req: WSF_REQUEST): BOOLEAN
			-- If a client has requested, or a cache is configured, to ignore server's expiration time,
			--  should we force revalidation anyway?
			-- If `True' then a Cache-Control: must-revalidate header will be generated.
		require
			req_attached: req /= Void
		do
			--  Redefine to force revalidation.
		end

	
	must_proxy_revalidate (req: WSF_REQUEST): BOOLEAN
			-- If a shared cache is configured to ignore server's expiration time,
			--  should we force revalidation anyway?
			-- If `True' then a Cache-Control: proxy-revalidate header will be generated.
		require
			req_attached: req /= Void
		do
			--  Redefine to force revalidation.
		end

		
	private_headers (req: WSF_REQUEST): detachable LIST [READABLE_STRING_8]
			-- Header names intended for a single user.
			-- If non-Void, then a Cache-Control: private header will be generated.
			-- Returning an empty list prevents the entire response from being served from a shared cache.
		require
			req_attached: req /= Void
		deferred
		ensure
			not_freely_cacheable: Result /= Void implies not is_freely_cacheable (req)
		end

	non_cacheable_headers (req: WSF_REQUEST): detachable LIST [READABLE_STRING_8]
			-- Header names that will not be sent from a cache without revalidation;
			-- If non-Void, then a Cache-Control: no-cache header will be generated.
			-- Returning an empty list prevents the response being served from a cache
			--  without revalidation.
		require
			req_attached: req /= Void
		deferred
		end

	is_sensitive (req: WSF_REQUEST): BOOLEAN
			-- Is the response to `req' of a sensitive nature?
			-- If `True' then a Cache-Control: no-store header will be generated.
		require
			req_attached: req /= Void
		deferred
		end

end
