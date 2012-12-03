note
	description: "[
				This class implements the web service

				It inherits from WSF_DEFAULT_SERVICE to get default EWF connector ready
				It just implements `execute'

				`initialize' can be redefine to provide custom options if needed.
			]"

class
	EWF_APPLICATION

inherit
	WSF_DEFAULT_SERVICE
		redefine
			initialize
		end

create
	make_and_launch

feature -- Execution

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Default request handler if no other are relevant
		local
			mesg: WSF_HTML_PAGE_RESPONSE
		do
			create mesg.make
			mesg.set_title ("Hello World!")
			mesg.set_body ("<h1>Hello World!</h1>")
			res.send (mesg)
		end

feature {NONE} -- Initialization

	initialize
		do
				--| The following line is to be able to load options from the file ewf.ini
			create {WSF_SERVICE_LAUNCHER_OPTIONS_FROM_INI} service_options.make_from_file ("ewf.ini")

				--| If you don't need any custom options, you are not obliged to redefine `initialize'
			Precursor
		end

end
