note
	description: "Summary description for {HTTP_METHODS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HTTP_METHODS

feature -- Method Names
	OPTIONS : STRING_32 = "OPTIONS"
	GET : STRING_32 = "GET"
	HEAD : STRING_32 = "HEAD"
	POST : STRING_32 = "POST"
	PUT	 : STRING_32 = "PUT"
	DELETE : STRING_32 = "DELETE"
	TRACE  : STRING_32 = "TRACE"
	CONNECT : STRING_32 = "CONNECT"
end
