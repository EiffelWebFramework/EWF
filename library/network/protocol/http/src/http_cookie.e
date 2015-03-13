note
	description: "[
			This class represents the value of a HTTP cookie, transferred in a request.
			The class has features to build an HTTP cookie.
			
			Following a newer RFC standard for Cookies RCF6265.
			
			Domain
			* WARNING: Some existing user agents treat an absent Domain attribute as if the Domain attribute were present and contained the current host name.  
			* For example, if example.com returns a Set-Cookie header without a Domain attribute, these user agents will erroneously send the cookie to www.example.com as well.
			
			Max-Age, Expires
			* If a cookie has both the Max-Age and the Expires attribute, the Max-Age attribute has precedence and controls the expiration date of the cookie. 
			* If a cookie has neither the Max-Age nor the Expires attribute, the user agent will retain the cookie until "the current session is over" (as defined by the user agent).
			* You will need to call the feature
			
			HttpOnly, Secure
			* Note that the HttpOnly attribute is independent of the Secure attribute: a cookie can have both the HttpOnly and the Secure attribute.

]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=HTTP Cookie specification", "src=https://httpwg.github.io/specs/rfc6265.html", "protocol=uri"
class
	HTTP_COOKIE

create
	make

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_32; a_value: READABLE_STRING_32)
			-- Create an object instance of cookie with name `a_name' and value `a_value'.
		require
			make_sense: (a_name /= Void and a_value /= Void) and then (not a_name.is_empty and not a_value.is_empty)
		do
			set_name (a_name)
			set_value(a_value)
			set_max_age (-1)
		ensure
			name_set: name = a_name
			value_set: value = a_value
			max_age_set: max_age < 0
		end

feature -- Access

	name: STRING_32
		-- name of the cookie.

	value: STRING_32
		-- value of the cookie.

	expiration: detachable STRING
		-- Value of the Expires attribute.

	path: detachable STRING_32
		-- Value of the Path attribute.
		-- Path to which the cookie applies.
		--| The path "/", specify a cookie that apply to all URLs in your site.

	domain: detachable STRING_32
		-- Value of the Domain attribute.
		-- Domain to which the cookies apply.

	secure: BOOLEAN
		-- Value of the Secure attribute.
		-- By default False.
		--| Idicate if the cookie should only be sent over secured(encrypted connections, for example SSL).

	http_only: BOOLEAN
		-- Value of the http_only attribute.
		-- By default false.
		--| Limits the scope of the cookie to HTTP   requests.

	max_age: INTEGER
		-- Value of the Max-Age attribute.
		--| How much time in seconds should elapsed before the cooki expires.
		--| By default max_age < 0 indicate a cookie will last only for the current user-agent (Browser, etc) session.
		--|	A value of 0 instructs the user-agent to delete the cookie.

	has_valid_characters (a_name: READABLE_STRING_32):BOOLEAN
			-- Has `a_name' valid characters for cookies?
		local
			l_iterator: STRING_ITERATION_CURSOR
			l_found: BOOLEAN
		do
			create l_iterator.make (a_name)
			from
				l_iterator.start
			until
				l_iterator.after or l_found
			loop
				if valid_characters.index_of (l_iterator.item.to_character_8, 0) = -1 then
					Result := False
					l_found := True
				else
					l_iterator.forth
				end
			end
		end

	include_max_age: BOOLEAN
		-- Does the Set-Cookie header will include Max-Age attribute?
		--|By default will include both.

	include_expires: BOOLEAN
		-- Does the Set-Cookie header will include Expires attribute?
		--|By default will include both.	

feature -- Change Element

	set_name (a_name: READABLE_STRING_32)
			-- Set `name' with `a_name'.
		do
			name := a_name
		ensure
			name_set: name = a_name
		end

	set_value (a_value: READABLE_STRING_32)
			-- Set `value' with `a_value'.
		do
			value := a_value
		ensure
			value_set:  value = a_value
		end

	set_expiration (a_date: READABLE_STRING_32)
			-- Set `expiration' with `a_date'
		do
			expiration := a_date
		ensure
			expiration_set: attached expiration as l_expiration and then l_expiration.same_string (a_date)
		end

	set_expiration_date (a_date: DATE_TIME)
			-- Set `expiration' with `a_date'
		do
			set_expiration (date_to_rfc1123_http_date_format (a_date))
		ensure
			expiration_set: attached expiration as l_expiration and then l_expiration.same_string (date_to_rfc1123_http_date_format (a_date))
		end

	set_path (a_path: READABLE_STRING_32)
			-- Set `path' with `a_path'
		do
			path := a_path
		ensure
			path_set: path = a_path
		end

	set_domain (a_domain: READABLE_STRING_32)
			-- Set `domain' with `a_domain'
			-- Note: you should avoid using "localhost" as `domain' for local cookies
			--       since they are not always handled by browser (for instance Chrome)
		require
			domain_without_port_info: a_domain /= Void implies a_domain.index_of (':', 1) = 0
		do
			domain := a_domain
		ensure
			domain_set: domain = a_domain
		end

	set_secure (a_secure: BOOLEAN)
			-- Set `secure' with `a_secure'
		do
			secure := a_secure
		ensure
			secure_set: secure = a_secure
		end

	set_http_only (a_http_only: BOOLEAN)
			-- Set `http_only' with `a_http_only'
		do
			http_only := a_http_only
		ensure
			http_only_set: http_only = a_http_only
		end

	set_max_age (a_max_age: INTEGER)
			-- Set `max_age' with `a_max_age'
		do
			max_age := a_max_age
		ensure
			max_age_set: max_age = a_max_age
		end


	mark_max_age
			-- Set `include_max_age' to True.
			-- Set `include_expires' to False.
			-- Set-Cookie will include only Max-Age attribute and not Expires.
		do
			include_max_age := True
			include_expires := False
		ensure
			max_age_true: include_max_age
			expire_false: not include_expires
		end

	mark_expires
			-- Set `include_expires' to True.
			-- Set `include_max_age' to False
 			-- Set-Cookie will include only Expires attribute and not Max_Age.
		do
			include_expires := True
			include_max_age := False
		ensure
			expires_true: include_expires
			max_age_false: not include_max_age
		end

	set_default_expires_max_age
			-- Set `include_expires' to False.
			-- Set `include_max_age' to False
	 		-- Set-Cookie will include both Max-Age, Expires attributes.
		do
			include_expires := False
			include_max_age := False
		ensure
				expires_false: not include_expires
				max_age_false: not include_max_age
		end

feature -- Date Utils

	date_to_rfc1123_http_date_format (dt: DATE_TIME): STRING_8
			-- String representation of `dt' using the RFC 1123
		local
			d: HTTP_DATE
		do
			create d.make_from_date_time (dt)
			Result := d.string
		end

feature -- Output

	cookie_header: STRING
			-- String representation of Set-Cookie header of current.
		local
			s: STRING
		do
			s := {HTTP_HEADER_NAMES}.header_set_cookie + colon_space + name + "=" + value
			if
				attached domain as l_domain and then not l_domain.same_string ("localhost")
			then
				s.append ("; Domain=")
				s.append (l_domain)
			end
			if attached path as l_path then
				s.append ("; Path=")
				s.append (l_path)
			end
				-- Expire
			if include_expires then
				if attached expiration as l_expires then
					s.append ("; Expires=")
					s.append (l_expires)
				end
				-- Max-Age
			elseif include_max_age then
				s.append ("; Max-Age=")
				s.append (max_age.out)
			else
				-- Default
				check default: (not include_expires) and (not include_max_age)  end
				if attached expiration as l_expires then
					s.append ("; Expires=")
					s.append (l_expires)
				end

				s.append ("; Max-Age=")
				s.append (max_age.out)
			end

			if secure then
				s.append ("; Secure")
			end
			if http_only then
				s.append ("; HttpOnly")
			end
			Result := s
		end

feature {NONE} -- Constants


	colon_space: IMMUTABLE_STRING_8
		once
			create Result.make_from_string (": ")
		end


	legal_characters, valid_characters: SPECIAL [CHARACTER_8]
			-- RFC6265 that specifies that the following is valid for characters in cookies. Cookies are also supposed to be double quoted.
			-- The following character ranges are valid:http://tools.ietf.org/html/rfc6265#section-4.1.1
			-- %x21 / %x23-2B / %x2D-3A / %x3C-5B / %x5D-7E
			-- 0x21: !
			-- 0x23-2B: #$%&'()*+
			-- 0x2D-3A: -./0123456789:
			-- 0x3C-5B: <=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[
			-- 0x5D-7E: ]^_`abcdefghijklmnopqrstuvwxyz{|}~
		note
			EIS: "name=valid-characters", "src=http://tools.ietf.org/html/rfc6265#section-4.1.1", "protocol=uri"
		once
			Result := ("!#$%%&'()*+-./0123456789:<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~").area
		end

note
	copyright: "2011-2015, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
