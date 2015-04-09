note
	description: "[
				This class implements the `Hello World' service.

				It inherits from WSF_DEFAULT_SERVICE to get default EWF connector ready
				And from WSF_URI_TEMPLATE_ROUTED_SERVICE to use the router service

				`initialize' can be redefine to provide custom options if needed.

			]"
	purpose: "[
		To demonstrate an interactive web site running on your local computer.
		]"
	examples: "[
		1. Start this application in workbench mode by pressing the "Run" button int
			the menu above.
		2. Open your favorite browser and enter the address: "http://localhost:9999/hello"
		
		NOTE: In the same directory as this projects ECF file, you will find another
			file called "ewf.ini". In this file is a setting telling this program
			which port to use as a communication channel on localhost. By default it
			is set to 9999. However, if this port is in use by some other service,
			please change it to an unused port and try again, but with whatever
			port number you select.
		]"
	glossary: "[
		map/mapping: A way to redirect an incoming request to the location of the content. 
			The mapping mechanism determines what code should be served when a particular 
			URI is requested. Virtual URI mapping allows you to create short, convenient 
			URLs that do not match the site hierarchy exactly.
		]"
	wiki_text: "[
		Tutorial Step 4
		Goal: Learn how to use Router (i.e: url dispatcher)
		Requirements: 
		* know how to compile with Eiffel (EiffelStudio).
		* [[step_3.wiki|Previous step ]] completed

		`hello' project
		* Let's start from the "hello" project
		* you will learn how to use the req: WSF_ROUTER component
		* See the hello project from [[step_4|step #4]] folder

		* You can find code in [[step_4]] folder :

		 To get a routed service based on URI Template, your service application class should inherit from WSF_URI_TEMPLATE_ROUTED_SERVICE
		 then you need to implement "setup_router", the following code is from the step_4 example

		See: `setup_router' in this class.

		----
		]"
class
	HELLO_APPLICATION

inherit
	WSF_ROUTED_SERVICE

	WSF_DEFAULT_SERVICE
		redefine
			initialize
		end

create
	make_and_launch

feature {NONE} -- Initialization

	setup_router
			-- See `setup_router' class-feature notes (below).
		note
			description: "[
				* `map_agent_uri' is used to handle the url /hello with the feature "execute_hello"
				* map_agent_response_with_request_methods is  similar but you precise the accepted 
					request methods
				* map and map_with_request_method are similar to previous "agent" variant, but it 
					is using a descendant of WSF_HANDLER to handle the related url.

				* In this example, we use the URI Template router, this allows to define the route
					using resource like /user/{user} , and then you get access to the "user" data
					from the WSF_REQUEST.path_parameter or using the context argument passed for
					the execute or response handler.

				* The example also includes basic notions of url, html encoding, check the hello.ecf
					to see the added libraries  (http to get easy access to the http status code,
					encoder for simple encoding components)
				]"
		do
--			router.map (create {WSF_URI_MAPPING}.make ("/hello", create {WSF_AGENT_URI_HANDLER}.make (agent execute_hello)))			
			map_agent_uri ("/hello", agent execute_hello, Void)

--			router.map_with_request_methods (create {WSF_URI_TEMPLATE_MAPPING}.make ("/users/{user}/message/{mesgid}", create {USER_MESSAGE_HANDLER}), router.methods_HEAD_GET_POST)
			map_uri_template ("/users/{user}/message/{mesgid}", create {USER_MESSAGE_HANDLER}, router.methods_HEAD_GET_POST)

--			router.map_with_request_methods (create {WSF_URI_TEMPLATE_MAPPING}.make ("/users/{user}/message/", create {USER_MESSAGE_HANDLER}), router.methods_GET_POST)
			map_uri_template ("/users/{user}/message/", create {USER_MESSAGE_HANDLER}, router.methods_GET_POST)

--			router.map_with_request_methods (create {WSF_URI_TEMPLATE_MAPPING}.make ("/users/{user}/{?op}", create {WSF_AGENT_URI_TEMPLATE_RESPONSE_HANDLER}.make (agent response_user)), router.methods_GET)
			map_agent_uri_template_response ("/users/{user}/{?op}", agent response_user, router.methods_GET)
		end

feature -- Helper: mapping

	map_agent_uri (a_uri: READABLE_STRING_8; a_action: like {WSF_URI_AGENT_HANDLER}.action; rqst_methods: detachable WSF_REQUEST_METHODS)
			-- See `map_agent_uri' class-feature notes (below).
		note
			purpose: "[
				To link `a_uri' mapping to `a_action' with "request methods" (see glossary below).
				]"
			how: "[
				By providing `a_action' handler to `a_uri' mapping, based on "request methods", this class
				is able to properly direct incoming client requests to the appropriate handler based on
				the request method in the HTML header and the structure of the request URI.
				]"
			glossary: "[
				request methods: The Hypertext Transfer Protocol (HTTP) is designed to enable communications 
					between clients and servers. HTTP works as a request-response protocol between a client 
					and server. A web browser may be the client, and an application on a computer that hosts 
					a web site may be the server. Example: A client (browser) submits an HTTP request to the 
					server; then the server returns a response to the client. The response contains status 
					information about the request and may also contain the requested content.
				Idempotence:  (/ˌaɪdɨmˈpoʊtəns/ EYE-dəm-POH-təns) is the property of certain operations in 
					mathematics and computer science, that can be applied multiple times without changing 
					the result beyond the initial application. For Eiffel, this is the notion of a "once".
				]"
			EIS: "name=w3_schools_http_request_tutorial", "protocol=URI", "src=http://www.w3schools.com/tags/ref_httpmethods.asp", "tag=external"
			EIS: "name=w3_org_RFC_2616_method_definitions", "protocol=URI", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html", "tag=external"
		do
			router.map_with_request_methods (create {WSF_URI_MAPPING}.make (a_uri, create {WSF_URI_AGENT_HANDLER}.make (a_action)), rqst_methods)
		end

	map_uri_template (a_uri_template: READABLE_STRING_8; a_handler: WSF_URI_TEMPLATE_HANDLER; a_request_methods: detachable WSF_REQUEST_METHODS)
			-- See `map_uri_template' class-feature notes (below).
		note
			purpose: "[
				To associate `a_handler' with `a_uri_template' and `rqst_methods'.
				]"
			how: "[
				By using `a_uri_template'
				]"
			glossary: "[
				URL Template: A URL Template is a way to specify a URL that includes parameters that 
					must be substituted before the URL is resolved. The syntax is usually to enclose 
					the parameter in Braces ({example}). Example from this class is:
					
					"/users/{user}/message/{mesgid}", where {user} and {mesgid} are parameters needing
					to be replaced before the URL is resolved.
					
					See: USER_MESSAGE_HANDLER as it demonstrates how to process /user/{user}/message/ requests.
				]"
		do
			router.map_with_request_methods (create {WSF_URI_TEMPLATE_MAPPING}.make (a_uri_template, a_handler), a_request_methods)
		end

	map_agent_uri_template_response (a_uri_template: READABLE_STRING_8; a_action: like {WSF_URI_TEMPLATE_RESPONSE_AGENT_HANDLER}.action; rqst_methods: detachable WSF_REQUEST_METHODS)
			-- See `map_agent_uri_template_response' class-feature notes (below).
		note
			purpose: "[
				Like `map_uri_template' above, but having `a_action'.
				]"
			how: "[
				By computing WSF_URI_TEMPLATE_RESPONSE_AGENT_HANDLER from `a_action' and linking
				it to an `a_uri_template' with `rqst_methods' context.
				]"
		do
			router.map_with_request_methods (create {WSF_URI_TEMPLATE_MAPPING}.make (a_uri_template, create {WSF_URI_TEMPLATE_RESPONSE_AGENT_HANDLER}.make (a_action)), rqst_methods)
		end

feature -- Execution

	execute_hello (a_request: WSF_REQUEST; a_response: WSF_RESPONSE)
			-- See `execute_hello' class-feature notes (below).
		note
			purpose: "[
				To respond to client browser request messages for the "hello" page (URI). This is
				called a "Computed Response Message".
				]"
			examples: "[
				Start this application. Once running, use the mouse to expand this editor window so
				the following EIS link is visible. Hover the mouse pointer over the "src" link below
				and click "open" to open in an Eiffel Studio Browser window -OR- click the
				"Open in browser" link to open in your default OS browser (e.g. Windows = IE). This
				presumes the port is set to 9999 and available. If not, then copy the link below,
				changing the port number to match the `configuration_file' setting.
				]"
			EIS: "name=hello_page", "protocol=URI", "src=http://localhost:9999/hello", "tag=external"
		local
			l_message: WSF_HTML_PAGE_RESPONSE
			l_html_response: STRING_8
			l_user_name: READABLE_STRING_32
		do
			--| It is now returning a WSF_HTML_PAGE_RESPONSE
			--| Since it is easier for building html page
			create l_message.make
			l_message.set_title ("EWF tutorial / Hello World!")
			--| Check if the request contains a parameter named "user"
			--| this could be a query, or a form parameter
			if attached {WSF_STRING} a_request.item (user_parameter_keyword) as al_user then
				--| If yes, say hello world #name

				l_user_name := (create {HTML_ENCODER}).decoded_string (al_user.value)

				l_html_response := "<p>Hello " + l_message.html_encoded_string (l_user_name) + "!</p>"
				l_html_response.append ("Display a <a href=%"/users/" + al_user.url_encoded_value + "/message/%">message</a></p>")
				l_html_response.append ("<p>Click <a href=%"/users/" + al_user.url_encoded_value + "/?op=quit%">here</a> to quit.</p>")
				l_message.set_body (l_html_response)
				--| We should html encode this name
				--| but to keep the example simple, we don't do that for now.
			else
				--| Otherwise, ask for name
				l_html_response := (create {HTML_ENCODER}).encoded_string ({STRING_32} "Hello / ahoj / नमस्ते / Ciào / مرحبا / Hola / 你好 / Hallo / Selam / Bonjour ")
				l_html_response.append ("[
							<form action="/hello" method="GET">
								What is your name?</p>
								<input type="text" name="<<USER_PARAMETER>>"/>
								<input type="submit" value="Validate"/>
							</form>
						]"
					)
				l_html_response.replace_substring_all (user_parameter_replacement_tag, user_parameter_keyword)
				l_message.set_body (l_html_response)
			end

			--| note:
			--| 1) Source of the parameter, we could have used
			--|		 a_request.query_parameter ("user") to search only in the query string
			--|		 a_request.form_parameter ("user") to search only in the form parameters
			--| 2) response type
			--| 	it could also have used WSF_PAGE_REPONSE, and build the html in the code
			--|

			a_response.send (l_message)
		end

	response_user (a_request: WSF_REQUEST): WSF_RESPONSE_MESSAGE
			-- Computed response message.
		local
			l_response_html: WSF_HTML_PAGE_RESPONSE
			l_redirection_response: WSF_HTML_DELAYED_REDIRECTION_RESPONSE
			l_body_html: STRING_8
			l_username: STRING_32
		do
			if attached {WSF_STRING} a_request.path_parameter (user_parameter_keyword) as al_user then
				l_username := (create {HTML_ENCODER}).general_decoded_string (al_user.value)
				if
					attached {WSF_STRING} a_request.query_parameter (op_parameter_keyword) as al_op_parm
				then
					if al_op_parm.is_case_insensitive_equal (quit_operation_keyword) then
						create l_redirection_response.make (a_request.script_url ("/hello"), 3)
						create l_response_html.make
						l_redirection_response.set_title ("Bye " + l_response_html.html_encoded_string (l_username))
						l_redirection_response.set_body ("Bye " + l_response_html.html_encoded_string (l_username) + ",<br/> see you soon.<p>You will be redirected to " +
										l_redirection_response.url_location + " in " + l_redirection_response.delay.out + " second(s) ...</p>"
								)
						Result := l_redirection_response
					else
						create l_response_html.make
						l_response_html.set_title ("Bad request")
						l_response_html.set_body ("Bad request: unknown operation '" + al_op_parm.url_encoded_value + "'.")
						Result := l_response_html
					end
				else
					create l_response_html.make

					l_body_html := "<p>User <em>'" + l_response_html.html_encoded_string (l_username)  + "'</em>!</p>"
					l_body_html.append ("Display a <a href=%"/users/" + al_user.url_encoded_value + "/message/%">message</a></p>")
					l_body_html.append ("<p>Click <a href=%"/users/" + al_user.url_encoded_value + "/?op=" + quit_operation_keyword + "%">here</a> to quit.</p>")
					l_response_html.set_title ("User '" + al_user.url_encoded_value + "'")
					l_response_html.set_body (l_body_html)
					Result := l_response_html
				end
			else
				create l_response_html.make
				l_response_html.set_title ("Bad request")
				l_response_html.set_body ("Bad request: missing user parameter")
				Result := l_response_html
			end
		end

feature {NONE} -- Initialization

	initialize
			-- See `initialize' class-feature notes (below).
		note
			purpose: "[
				To initialize Current from the `configuration_file' settings (e.g. port number setting).
				]"
			how: "[
				By executing 3 basic steps:
				1. Set the web service options from the `configuration_file'.
				2. Call any Precursor code.
				3. Initialize the router.
				
				NOTE: If you don't need any custom options, you are not obliged to redefine `initialize'
				]"
			glossary: "[
				Web service: From Wikipedia, the free encyclopedia - A Web service is a method of 
					communication between two electronic devices over a network. It is a software function 
					provided at a network address over the web with the service always on as in the concept 
					of utility computing. The W3C defines a Web service generally as: a software system 
					designed to support interoperable machine-to-machine interaction over a network.
				]"
		do
			create {WSF_SERVICE_LAUNCHER_OPTIONS_FROM_INI} service_options.make_from_file (configuration_file)
			Precursor
			initialize_router
		end

feature {NONE} -- Implementation: Constants

	configuration_file: STRING = "ewf.ini"
			-- Configuration file used to initialize Current.

	user_parameter_keyword: STRING = "user"
			-- Keyword for "user" parameter.

	user_parameter_replacement_tag: STRING = "<<USER_PARAMETER>>"
			-- Tag string used for "macro replacement" in larger strings.

	op_parameter_keyword: STRING = "op"
			-- Keyword for "op" (operation) parameter.

	quit_operation_keyword: STRING = "quit"
			-- Keyword for "quit" parameter.

end
