note
	description: "Object that describe a cookie. When returning Cookie objects, the server should only omit an optional field if it is incapable of providing the information."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEB_DRIVER_COOKIE

create
	make
feature {NONE}-- Initialization
	make (a_name : STRING_32; a_value: STRING_32)
		do
			set_name (a_name)
			set_value (a_value)
		end

feature -- Access
	name : STRING_32
		--The name of the cookie.

	value : STRING_32
		--	The cookie value.

	path : detachable STRING_32
		--(Optional) The cookie path

	domain : detachable STRING_32
		--(Optional) The domain the cookie is visible to.

	secure : BOOLEAN
		--(Optional) Whether the cookie is a secure cookie

	expiry : NATURAL_32
		-- (Optional) When the cookie expires, specified in seconds since midnight, January 1, 1970 UTC.1

feature -- Change Element
	set_name (a_name:STRING_32)
		do
			name := a_name
		end

	set_value (a_value:STRING_32)
		do
			value := a_value
		end

	set_path (a_path : STRING_32)
		do
			path := a_path
		end

	set_domain (a_domain : STRING_32)
		do
			domain := a_domain
		end

	set_secure (a_value : BOOLEAN)
		do
			secure := a_value
		end

	set_expiry ( a_value : NATURAL_32)
		do
			expiry := a_value
		end

end
