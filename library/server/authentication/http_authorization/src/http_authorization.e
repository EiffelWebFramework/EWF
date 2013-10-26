note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	HTTP_AUTHORIZATION

inherit
	REFACTORING_HELPER

create
	make,
	make_basic_auth,
	make_custom_auth

feature {NONE} -- Initialization

	make (a_http_authorization: detachable READABLE_STRING_8)
			-- Initialize 'Current' with 'a_http_authorization'.
		local
			i: INTEGER
			s, l_type, l_login, l_password: STRING_8
		do
			if a_http_authorization /= Void then
				s := a_http_authorization.as_string_8
				http_authorization := s
				if not s.is_empty then
					i := 1
					if s [i] = ' ' then
						i := i + 1
					end
					i := s.index_of (' ', i)
					if i > 0 then
						l_type := s.substring (1, i - 1).as_lower
						l_type.right_adjust; l_type.left_adjust
						type := l_type
						if l_type.same_string (Basic_type) then
							s := (create {BASE64}).decoded_string (s.substring (i + 1, s.count))
							i := s.index_of (':', 1) --| Let's assume ':' is forbidden in login ...
							if i > 0 then
								l_login := s.substring (1, i - 1).as_string_32
								l_password := s.substring (i + 1, s.count).as_string_32
								login := l_login
								password := l_password
								check
									(create {HTTP_AUTHORIZATION}.make_custom_auth (l_login, l_password, l_type)).http_authorization ~ http_authorization
								end
							end
						elseif l_type.same_string ("digest") then
							to_implement ("HTTP Authorization %"digest%", not yet implemented")
						else
							to_implement ("HTTP Authorization %""+ l_type +"%", not yet implemented")
						end
					end
				end
			else
			end
		end

	make_basic_auth (a_login: READABLE_STRING_GENERAL; a_password: READABLE_STRING_GENERAL)
			-- Use 'a_login' as login, 'a_password' as password and 'Basic_type' as type.
		do
			make_custom_auth (a_login, a_password, Basic_type)
		ensure
			login_effect: login /= Void and then login.same_string (a_login.as_string_32)
			password_effect: password /= Void and then password.same_string (a_password.as_string_32)
			is_basic: is_basic
		end

	make_custom_auth (a_login: READABLE_STRING_GENERAL; a_password: READABLE_STRING_GENERAL; a_type: READABLE_STRING_8)
			-- Use 'a_login' as login, 'a_password' as password and 'a_type' as type.
		local
			l_type: STRING_8
		do
			create login.make_from_string_general (a_login)
			create password.make_from_string_general (a_password)
			l_type := a_type.as_string_8
			l_type := l_type.as_lower
			l_type.left_adjust; l_type.right_adjust
			type := l_type
			if l_type.same_string (Basic_type) then
				create http_authorization.make_from_string ("Basic " + (create {BASE64}).encoded_string (login.string + ":" + password.string))
			else
				to_implement ("HTTP Authorization %""+ l_type +"%", not yet implemented")
			end
		ensure
			login_effect: login /= Void and then login.same_string (a_login.as_string_32)
			password_effect: password /= Void and then password.same_string (a_password.as_string_32)
		end

feature -- Access

	Basic_type: STRING_8 = "basic"

	type: detachable IMMUTABLE_STRING_8
		note
			option: stable
		attribute
		end

	login: detachable IMMUTABLE_STRING_32
		note
			option: stable
		attribute
		end

	password: detachable IMMUTABLE_STRING_32
		note
			option: stable
		attribute
		end

	http_authorization: detachable IMMUTABLE_STRING_8
		note
			option: stable
		attribute
		end

feature -- Status report

	is_basic: BOOLEAN
			-- Is Basic authorization?
		do
			Result := type /= Void and then type.same_string (Basic_type)
		end

invariant
	type_is_lower: type /= Void implies type.same_string (type.as_lower)
end
