note
	description: "Summary description for {CMS_STORAGE_AUTH_ENGINE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_STORAGE_AUTH_ENGINE

inherit
	CMS_AUTH_ENGINE

create
	make

feature {NONE} -- Initialization

	make (a_storage: like storage)
		do
			storage := a_storage
		end

	storage: CMS_STORAGE

feature -- Status

	valid_credential (u,p: READABLE_STRING_32): BOOLEAN
		do
			if attached storage.user_by_name (u) as l_user then
				Result := attached l_user.encoded_password as l_pass and then l_pass.same_string (storage.encoded_password (p))
			end
		end

end
