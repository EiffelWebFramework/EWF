note
	description: "[
				APPLICATION implements the "Hello World" service.

				It inherits from WSF_DEFAULT_SERVICE to get default EWF connector ready
				only `execute' needs to be implemented.

			]"

class
	APPLICATION

inherit
	WSF_DEFAULT_RESPONSE_SERVICE
		redefine
			initialize
		end

create
	make_and_launch

feature {NONE} -- Initialization

	initialize
		do
			create {WSF_SERVICE_LAUNCHER_OPTIONS_FROM_INI} service_options.make_from_file ("ewf.ini")
			Precursor
		end

feature {NONE} -- Initialization

	response (req: WSF_REQUEST): WSF_PAGE_RESPONSE
		do
			create Result.make
			Result.put_string ("Hello World")
		end

end
