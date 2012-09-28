note
	description: "[
				This class implements the web service

				It inherits from WSF_DEFAULT_SERVICE to get default EWF connector ready
				And from WSF_URI_TEMPLATE_ROUTED_SERVICE to use the router service

				`initialize' can be redefine to provide custom options if needed.
			]"

class
	EWF_APPLICATION

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
			-- Set the router here
			map_uri_template_agent ("/hello/{user}", agent execute_hello)
		end

feature -- Execution

	execute_default (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Default request handler if no other are relevant
		local
			l_url: READABLE_STRING_8
		do
			-- The following code is provided as example, feel free to replace with your the code

			l_url := req.script_url ("/hello/world")
			res.redirect_now_with_content (l_url, "Redirection to " + l_url, "text/html")
		end

	execute_hello (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Computed response message.
		local
			mesg: WSF_HTML_PAGE_RESPONSE
			s: STRING_8
			l_user_name: READABLE_STRING_32
		do
			-- The following code is provided as example, feel free to replace with your the code

			--| It is now returning a WSF_HTML_PAGE_RESPONSE
			--| Since it is easier for building html page
			create mesg.make
			mesg.set_title ("Hello World!")
			--| Check if the request contains a parameter named "user"
			--| this could be a query, or a form parameter
			if attached {WSF_STRING} req.item ("user") as u then
				--| If yes, say hello world #name
				l_user_name := (create {HTML_ENCODER}).decoded_string (u.value)
				s := "<p>Hello " + mesg.html_encoded_string (l_user_name) + "!</p>"
				mesg.set_body (s)
				--| We should html encode this name
				--| but to keep the example simple, we don't do that for now.
			else
				--| Otherwise, ask for name
				s := (create {HTML_ENCODER}).encoded_string ({STRING_32} "Hello / ahoj / नमस्ते / Ciào / مرحبا / Hola / 你好 / Hallo / Selam / Bonjour ")
				s.append ("[
							<form action="/hello" method="GET">
								What is your name?</p>
								<input type="text" name="user"/>
								<input type="submit" value="Validate"/>
							</form>
						]"
					)
				mesg.set_body (s)
			end
			res.send (mesg)
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
