note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	WSF_FORCE_DOWNLOAD_RESPONSE

inherit
	WSF_DOWNLOAD_RESPONSE
		redefine
			get_content_type
		end

create
	make

feature {NONE} -- Implementation

	get_content_type
		do
			content_type := {HTTP_MIME_TYPES}.application_force_download
		end

end
