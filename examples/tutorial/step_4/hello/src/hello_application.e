note
	description: "[
				This class implements the `Hello World' service.

				It inherits from WSF_DEFAULT_SERVICE to get default EWF connector ready
				only `response' needs to be implemented.
				In this example, it is redefined and specialized to be WSF_PAGE_RESPONSE

				`initialize' can be redefine to provide custom options if needed.

			]"

class
	HELLO_APPLICATION

inherit
	WSF_URI_TEMPLATE_ROUTED_SERVICE

	WSF_DEFAULT_SERVICE
		redefine
			initialize
		end

create
	make_and_launch

feature {NONE} -- Initialization

	setup_router
		do
			router.map_agent ("/hello", agent execute_hello)
			router.map_agent_response_with_request_methods ("/{user}/bye", agent response_bye, <<"GET">>)
		end

feature -- Execution

	execute_default (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Default request handler if no other are relevant
		do
			res.redirect_now_with_content (req.script_url ("/hello"), "Redirection to " + req.script_url ("/hello"), "text/html")
		end

	execute_hello (ctx: WSF_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Computed response message.
		local
			mesg: WSF_HTML_PAGE_RESPONSE
		do
			--| It is now returning a WSF_HTML_PAGE_RESPONSE
			--| Since it is easier for building html page
			create mesg.make
			mesg.set_title ("EWF tutorial / Hello World!")
			--| Check if the request contains a parameter named "user"
			--| this could be a query, or a form parameter
			if attached req.string_item ("user") as u then
				--| If yes, say hello world #name
				mesg.set_body ("Hello " + u + "!<br/>Click <a href=%"/" + u + "/bye%">here</a> to quit.")
				--| We should html encode this name
				--| but to keep the example simple, we don't do that for now.
			else
				--| Otherwise, ask for name
				mesg.set_body ("[
							<form action="/hello" method="POST">
								<p>Hello, what is your name?</p>
								<input type="text" name="user"/>
								<input type="submit" value="Validate"/>
							</form>
						]"
					)
			end

			--| note:
			--| 1) Source of the parameter, we could have used
			--|		 req.query_parameter ("user") to search only in the query string
			--|		 req.form_parameter ("user") to search only in the form parameters
			--| 2) response type
			--| 	it could also have used WSF_PAGE_REPONSE, and build the html in the code
			--|

			res.send (mesg)
		end

	response_bye (ctx: WSF_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST): WSF_RESPONSE_MESSAGE
			-- Computed response message.
		local
			html: WSF_HTML_PAGE_RESPONSE
			redir: WSF_HTML_DELAYED_REDIRECTION_RESPONSE
		do
			if attached ctx.string_path_parameter ("user") as u then
				create redir.make (req.script_url ("/hello"), 5)
				redir.set_title ("Bye " + u)
				redir.set_body ("Bye " + u + ",<br/> see you soon.<p>You will be redirected to " + redir.url_location + " in " + redir.delay.out + " second(s) ...</p>")
				Result := redir
			else
				create html.make
				html.set_title ("Bad request")
				html.set_body ("Bad request: missing user parameter")
				Result := html
			end
		end

feature {NONE} -- Initialization

	initialize
		do
				--| The following line is to be able to load options from the file ewf.ini
			create {WSF_SERVICE_LAUNCHER_OPTIONS_FROM_INI} service_options.make_from_file ("ewf.ini")

				--| If you don't need any custom options, you are not obliged to redefine `initialize'
			Precursor

				--| Initialize router
			initialize_router
		end


end
