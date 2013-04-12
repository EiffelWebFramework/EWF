note
	description: "Object that describe available features a client can submit in a WebDriver session. Not all server implementations will support every WebDriver feature."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Capabilities", "protocl=http", "src=https://code.google.com/p/selenium/wiki/JsonWireProtocol#Desired_Capabilities"
class
	SE_CAPABILITIES

create
	make
feature -- Initialization
	make
		-- defaults initializations
		do
		end

feature -- Access
	browser_name : detachable STRING_32
		--The name of the browser being used; should be one of {chrome|firefox|htmlunit|internet explorer|iphone}

	version : detachable STRING_32
		-- The browser version, or the empty string if unknown.

	platform : detachable STRING_32
		-- A key specifying which platform the browser is running on. This value should be one of {WINDOWS|XP|VISTA|MAC|LINUX|UNIX}.
		-- When requesting a new session, the client may specify ANY to indicate any available platform may be used.

	is_javascript_enabled : BOOLEAN
		--Whether the session supports executing user supplied JavaScript in the context of the current page.

	takes_screenshot : BOOLEAN
		--Whether the session supports taking screenshots of the current page.

	handles_alerts : BOOLEAN
		--Whether the session can interact with modal popups, such as window.alert and window.confirm.

	is_database_enabled : BOOLEAN
		--Whether the session can interact database storage.

	is_location_context_enabled : BOOLEAN
		--Whether the session can set and query the browser's location context.

	is_application_cache_enabled : BOOLEAN
		--Whether the session can interact with the application cache.

	is_browser_connection_enabled : BOOLEAN
		--Whether the session can query for the browser's connectivity and disable it if desired.

	is_css_selectors_enabled : BOOLEAN
		--Whether the session supports CSS selectors when searching for elements.

	is_web_storage_enabled : BOOLEAN
		--Whether the session supports interactions with storage objects.

	is_rotatable : BOOLEAN
		--Whether the session can rotate the current page's current layout between portrait and landscape orientations (only applies to mobile platforms).

	accept_ssl_certs : BOOLEAN
		--Whether the session should accept all SSL certs by default.

	native_events : BOOLEAN
		--Whether the session is capable of generating native events when simulating user input.

	proxy : detachable WEB_DRIVER_PROXY
		--Details of any proxy to use. If no proxy is specified, whatever the system's current or default state is used. The format is specified under Proxy JSON Object.

feature -- Change Elemenet
	set_browser_name (a_browser_name : STRING_32)
		do
			browser_name := a_browser_name
		end

	set_version (a_version : STRING_32)
		do
			version := a_version
		end

	set_platform (a_platform : STRING_32)
		do
			platform := a_platform
		end

	set_javascript_enabled ( value : BOOLEAN)
		do
			is_javascript_enabled := value
		end

	set_takes_screenshot (value : BOOLEAN)
		do
			takes_screenshot := value
		end

	set_handles_alerts ( value: BOOLEAN)
		do
			handles_alerts := value
		end

	set_database_enabled (value : BOOLEAN)
		do
			is_database_enabled := value
		end

	set_location_context_enabled (value:BOOLEAN)
		do
			is_location_context_enabled := value
		end

	set_application_cache_enabled (value : BOOLEAN)
		do
			is_application_cache_enabled := value
		end

	set_browser_connection_enabled (value : BOOLEAN)
		do
			is_browser_connection_enabled := value
		end

	set_css_selectors_enabled (value : BOOLEAN)
		do
			is_css_selectors_enabled := value
		end

	set_web_storage_enabled (value : BOOLEAN)
		do
			is_web_storage_enabled := value
		end

	set_rotatable (value : BOOLEAN)
		do
			is_rotatable := value
		end

	set_accept_ssl_certs (value : BOOLEAN)
		do
			accept_ssl_certs := value
		end

	set_native_events ( value : BOOLEAN)
		do
			native_events := value
		end

	set_proxy ( a_proxy : WEB_DRIVER_PROXY)
		do
			proxy := a_proxy
		end

end
