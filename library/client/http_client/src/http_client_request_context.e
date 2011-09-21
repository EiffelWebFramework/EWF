note
	description: "Summary description for {HTTP_CLIENT_REQUEST_CONTEXT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HTTP_CLIENT_REQUEST_CONTEXT

create
	make

feature {NONE} -- Initialization

	make
		do
			create headers.make (2)
			create query_parameters.make (5)
			create form_data_parameters.make (10)
		end

feature -- Settings

	credentials_required: BOOLEAN

feature -- Access

	headers: HASH_TABLE [READABLE_STRING_8, READABLE_STRING_8]

	query_parameters: HASH_TABLE [READABLE_STRING_32, READABLE_STRING_8]

	form_data_parameters: HASH_TABLE [READABLE_STRING_32, READABLE_STRING_8]

feature -- Status report

	has_form_data: BOOLEAN
		do
			Result := not form_data_parameters.is_empty
		end

feature -- Element change

	set_credentials_required (b: BOOLEAN)
		do
			credentials_required := b
		end

end
