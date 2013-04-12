note
	description: "Summary description for {SE_CAPABILITIES_JSON_CONVERTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SE_CAPABILITIES_JSON_CONVERTER

inherit

	SE_JSON_CONVERTER

create
	make

feature {NONE} -- Initialization

	make
		do
			create object.make
		end

feature -- Access

	object: SE_CAPABILITIES

feature -- Conversion

	from_json (j: like to_json): detachable like object
		do
			create Result.make
			if attached {STRING_32} json_to_object (j.item (browser_name_key), Void) as l_item then
				Result.set_browser_name(l_item)
			end
			if attached {STRING_32} json_to_object (j.item (version_key), Void) as l_item then
				Result.set_version(l_item)
			end
			if attached {STRING_32} json_to_object (j.item (platform_key), Void) as l_item then
				Result.set_platform(l_item)
			end
			if attached {BOOLEAN} json_to_object (j.item (javascriptenabled_key), Void) as l_item then
				Result.set_javascript_enabled(l_item)
			end
			if attached {BOOLEAN} json_to_object (j.item (takesscreenshot_key), Void) as l_item then
				Result.set_takes_screenshot(l_item)
			end
			if attached {BOOLEAN} json_to_object (j.item (handlesalerts_key ), Void) as l_item then
				Result.set_handles_alerts(l_item)
			end
			if attached {BOOLEAN} json_to_object (j.item (locationcontextenabled_key ), Void) as l_item then
				Result.set_location_context_enabled (l_item)
			end
			if attached {BOOLEAN} json_to_object (j.item (applicationcacheenabled_key ), Void) as l_item then
				Result.set_application_cache_enabled (l_item)
			end
			if attached {BOOLEAN} json_to_object (j.item (browserconnectionenabled_key ), Void) as l_item then
				Result.set_browser_connection_enabled (l_item)
			end
			if attached {BOOLEAN} json_to_object (j.item (cssselectorsenabled_key ), Void) as l_item then
				Result.set_css_selectors_enabled (l_item)
			end
			if attached {BOOLEAN} json_to_object (j.item (webstorageenabled_key ), Void) as l_item then
				Result.set_web_storage_enabled (l_item)
			end
			if attached {BOOLEAN} json_to_object (j.item (rotatable_key ), Void) as l_item then
			 	Result.set_rotatable (l_item)
			end
			if attached {BOOLEAN} json_to_object (j.item (acceptsslcerts_key ), Void) as l_item then
				Result.set_accept_ssl_certs (l_item)
			end
			if attached {BOOLEAN} json_to_object (j.item (nativeevents_key ), Void) as l_item then
				Result.set_native_events (l_item)
			end

--			if attached {WEB_DRIVER_PROXY} json_to_object (j.item (proxy_key), {WEB_DRIVER_PROXY}) as lv then
--				Result.set_proxy(lv)
--			end

		end

	to_json (o: like object): JSON_OBJECT
		do
			create Result.make
			Result.put (json.value (o.browser_name),browser_name_key)
			Result.put (json.value (o.version),version_key)
			Result.put (json.value (o.platform),platform_key)
			Result.put (json.value (o.is_javascript_enabled),javascriptenabled_key)
			Result.put (json.value (o.takes_screenshot),takesscreenshot_key)
			Result.put (json.value (o.handles_alerts),handlesalerts_key)
			Result.put (json.value (o.is_database_enabled),databaseenabled_key)
			Result.put (json.value (o.is_location_context_enabled),locationcontextenabled_key)
			Result.put (json.value (o.is_application_cache_enabled),applicationcacheenabled_key)
			Result.put (json.value (o.is_browser_connection_enabled),browserconnectionenabled_key)
			Result.put (json.value (o.is_css_selectors_enabled),cssselectorsenabled_key)
			Result.put (json.value (o.is_web_storage_enabled),webstorageenabled_key)
			Result.put (json.value (o.is_rotatable),rotatable_key)
			Result.put (json.value (o.accept_ssl_certs),acceptsslcerts_key)
			Result.put (json.value (o.native_events),nativeevents_key)
			--Result.put (json.value (o.proxy),proxy_key)
		end

feature {NONE} -- Implementation

	browser_name_key: JSON_STRING
		once
			create Result.make_json ("browserName")
		end

	version_key: JSON_STRING
		once
			create Result.make_json ("version")
		end

	platform_key: JSON_STRING
		once
			create Result.make_json ("platform")
		end

	javascriptEnabled_key: JSON_STRING
		once
			create Result.make_json ("javascriptEnabled")
		end

	takesScreenshot_key: JSON_STRING
		once
			create Result.make_json ("takesScreenshot")
		end

	handlesAlerts_key: JSON_STRING
		once
			create Result.make_json ("handlesAlerts")
		end

	databaseEnabled_key: JSON_STRING
		once
			create Result.make_json ("databaseEnabled")
		end

	locationContextEnabled_key: JSON_STRING
		once
			create Result.make_json ("locationContextEnabled")
		end

	applicationCacheEnabled_key: JSON_STRING
		once
			create Result.make_json ("applicationCacheEnabled")
		end

	browserConnectionEnabled_key: JSON_STRING
		once
			create Result.make_json ("browserConnectionEnabled")
		end

	cssSelectorsEnabled_key: JSON_STRING
		once
			create Result.make_json ("cssSelectorsEnabled")
		end

	webStorageEnabled_key: JSON_STRING
		once
			create Result.make_json ("webStorageEnabled")
		end

	rotatable_key: JSON_STRING
		once
			create Result.make_json ("rotatable")
		end

	acceptSslCerts_key: JSON_STRING
		once
			create Result.make_json ("acceptSslCerts")
		end

	nativeEvents_key: JSON_STRING
		once
			create Result.make_json ("nativeEvents")
		end

	proxy_key: JSON_STRING
		once
			create Result.make_json ("proxy")
		end

end
