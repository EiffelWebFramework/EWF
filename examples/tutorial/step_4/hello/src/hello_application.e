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


			router.map_with_request_methods ("/users/{user}/message/{mesgid}", create {USER_MESSAGE_HANDLER}, <<"GET", "POST">>)
			router.map_with_request_methods ("/users/{user}/message/", create {USER_MESSAGE_HANDLER}, <<"GET", "POST">>)

			router.map_agent_response_with_request_methods ("/users/{user}/{?op}", agent response_user, <<"GET">>)
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
			s: STRING_8
		do
			--| It is now returning a WSF_HTML_PAGE_RESPONSE
			--| Since it is easier for building html page
			create mesg.make
			mesg.set_title ("EWF tutorial / Hello World!")
			--| Check if the request contains a parameter named "user"
			--| this could be a query, or a form parameter
			if attached {WSF_STRING} req.item ("user") as u then
				--| If yes, say hello world #name
				s := "<p>Hello " + u.html_encoded_string + "!</p>"
				s.append ("Display a <a href=%"/users/" + u.url_encoded_string + "/message/%">message</a></p>")
				s.append ("<p>Click <a href=%"/users/" + u.url_encoded_string + "/?op=quit%">here</a> to quit.</p>")
				mesg.set_body (s)
				--| We should html encode this name
				--| but to keep the example simple, we don't do that for now.
			else
				--| Otherwise, ask for name
				s := (create {HTML_ENCODER}).encoded_string ({STRING_32} "Hello / ahoj / नमस्ते / Ciào / مرحبا / Hola / 你好 / Hallo / Selam / Bonjour ")
				s.append ("[
							<form action="/hello" method="POST">
								What is your name?</p>
								<input type="text" name="user"/>
								<input type="submit" value="Validate"/>
							</form>
						]"
					)
				mesg.set_body (s)
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

	response_user (ctx: WSF_URI_TEMPLATE_HANDLER_CONTEXT; req: WSF_REQUEST): WSF_RESPONSE_MESSAGE
			-- Computed response message.
		local
			html: WSF_HTML_PAGE_RESPONSE
			redir: WSF_HTML_DELAYED_REDIRECTION_RESPONSE
			s: STRING_8
		do
			if attached {WSF_STRING} ctx.path_parameter ("user") as u then
				if
					attached {WSF_STRING} req.query_parameter ("op") as l_op
				then
					if l_op.is_case_insensitive_equal ("quit") then
						create redir.make (req.script_url ("/hello"), 5)
						redir.set_title ("Bye " + u.url_encoded_string)
						redir.set_body ("Bye " + u.url_encoded_string + ",<br/> see you soon.<p>You will be redirected to " +
										redir.url_location + " in " + redir.delay.out + " second(s) ...</p>"
								)
						Result := redir
					else
						create html.make
						html.set_title ("Bad request")
						html.set_body ("Bad request: unknown operation '" + l_op.url_encoded_string + "'.")
						Result := html
					end
				else
					s := "<p>User <em>'" + u.url_encoded_string + "'</em>!</p>"
					s.append ("Display a <a href=%"/users/" + u.url_encoded_string + "/message/%">message</a></p>")
					s.append ("<p>Click <a href=%"/users/" + u.url_encoded_string + "/?op=quit%">here</a> to quit.</p>")
					create html.make
					html.set_title ("User '" + u.url_encoded_string + "'")
					html.set_body (s)
					Result := html
				end
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
