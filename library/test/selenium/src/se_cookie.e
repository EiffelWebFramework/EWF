note
	description: "Objects that describe a cookie. When returning Cookie objects, the server should only omit an optional field if it is incapable of providing the information."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SE_COOKIE

create
	default_create, make_with_values

feature -- Initialization

	make_with_values (a_name: STRING_32; a_value: STRING_32; a_path: STRING_32; a_domain: STRING_32)
		do
			set_name (a_name)
			set_path (a_path)
			set_value (a_value)
			set_domain (a_domain)
		end

feature -- Access

	name: detachable STRING_32
			--The name of the cookie.

	value: detachable STRING_32
			--	The cookie value.

	path: detachable STRING_32
			--(Optional) The cookie path

	domain: detachable STRING_32
			--(Optional) The domain the cookie is visible to.

	is_secure: BOOLEAN
			--(Optional) Whether the cookie is a secure cookie

	expiry: NATURAL_32
			-- (Optional) When the cookie expires, specified in seconds since midnight, January 1, 1970 UTC.1

feature -- Change Element

	set_name (a_name: STRING_32)
		do
			name := a_name
		ensure
			assigned_name: name ~ a_name
		end

	set_value (a_value: STRING_32)
		do
			value := a_value
		ensure
			assigned_value: value ~ a_value
		end

	set_path (a_path: STRING_32)
		do
			path := a_path
		ensure
			assigned_path: path ~ a_path
		end

	set_domain (a_domain: STRING_32)
		do
			domain := a_domain
		ensure
			assigned_domain: domain ~ a_domain
		end

	secure
			-- set the cookie as secure
		do
			is_secure := True
		ensure
			is_secure: is_secure
		end

	insecure
			-- set the cookie as insecure
		do
			is_secure := False
		ensure
			is_not_secure: not is_secure
		end

	set_expiry (an_expiry: NATURAL)
		do
			expiry := an_expiry
		ensure
			assigned_expiry: expiry ~ an_expiry
		end

end
