# Implementing WSF_CACHING_POLICY

This class contains a large number of routines, some of which have sensible defaults.

## age

This is used to generate a **Cache-Control: max-age** header. It says how old the response can before a cache will consider it stale (and therefore will need to revalidate with the server). Common values are zero (always consider it stale) and Never_expires (never always mean up to one year) and 1440 (one day).

## shared_age

This defaults to the same as age, so you only have to redefine it if you want a different value. If different from age, then we generate a **Cache-Control: s-max-age** header. This applies to shared caches only. Otherwise it has the same meaning as age. This overrides the value specified in age for shared caches.

## http_1_0_age

This generates an **Expires** header, and has the same meaning as age, but is understood by HTTP/1.0 caches. By default it has the same value as age. You only need to redefine this if you want to treat HTTP/1.0 caches differently (you might not trust them so well, so you might want to return 0 here).

## is_freely_cacheable

This routine says whether a shared cache can use this response for all client. If True, then it generates a **Cache-Control: public** header. If your data is at all sensitive, then you want to return False here.

## is_transformable

Non-transparent proxies are allowed to make some modifications to headers. If your application relies on this _not_ happening, then you want to return False here. This is the default, so you don't have to do anything. This means a **Cache-Control: no-transform** header will be generated.
But most applications can return True.

## must_revalidate

Some clients request that their private cache ignores server expiry times (and so freely reuse stale responses). If you want to force revalidation anyway in such circumstances, then redefine to return True. In which case, we generate a **Cache-Control: must-revalidate** header.

## must_proxy_revalidate

This is the same as must_revalidate, but only applies to shared caches that are configured to serve stale responses. If you redefine to return True, then we generate a **Cache-Control: proxy-revalidate** header.

## private_headers

This is used to indicate that parts (or all) of a response are considered private to a single user, and should not be freely served from a shared cache. You must implement this routine. Your choices are:

1. Return Void. None of the response is considered private.
1. Return and empty list. All of the response is considered private. 
1. Return a list of header names.

If you don't return Void, then a **Cache-Control: private** header will be generated.

## non_cacheable_headers

This is similar to private_headers, and you have the same three choices. the difference is that it is a list of headers (or the whole response) that will not be sent from a cache without revalidation.

If you don't return Void, then a **Cache-Control: no-cache** header will be generated.

## is_sensitive

Is the response to be considered of a sensitive nature? If so, then it will not be archived from a cache. We generate a **Cache-Control: no-store** header.