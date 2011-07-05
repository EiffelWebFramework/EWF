note
	description: "[
		Contains all information of a rfc2109 cookie that was read from the request header
	]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	GW_COOKIE

create
	make

convert
	value: {READABLE_STRING_8, STRING_8, READABLE_STRING_GENERAL, STRING_GENERAL}

feature {NONE} -- Initialization	

	make (a_name: STRING; a_value: STRING)
			-- Creates current.
		require
			a_name_not_empty: a_name /= Void and then not a_name.is_empty
			a_value_not_empty: a_value /= Void and then not a_value.is_empty
		do
			name := a_name
			value := a_value
		ensure
			a_name_set: name = a_name
			a_value_set: value = a_value
		end

feature -- Access

	name: STRING
		--  Required.  The name of the state information ("cookie") is NAME,
		--  and its value is VALUE.  NAMEs that begin with $ are reserved for
		--  other uses and must not be used by applications.

	value: STRING
		-- The VALUE is opaque to the user agent and may be anything the
		-- origin server chooses to send, possibly in a server-selected
		-- printable ASCII encoding.  "Opaque" implies that the content is of
		-- interest and relevance only to the origin server.  The content
		-- may, in fact, be readable by anyone that examines the Set-Cookie
		-- header.

feature -- Query

	variables: detachable HASH_TABLE [STRING, STRING]
			-- Potential variable contained in the encoded cookie's value.

feature -- Status report

	value_is_string (s: READABLE_STRING_GENERAL): BOOLEAN
			-- Is `value' same string as `s'
		do
			Result := s.same_string (value)
		end

invariant
	name_attached: name /= Void
	value_attached: value /= Void

note
	copyright: "2011-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
