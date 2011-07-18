note
	description: "Summary description for {HTTP_REQUEST_METHOD_CONSTANTS}."
	date: "$Date$"
	revision: "$Revision$"

class
	HTTP_REQUEST_METHOD_CONSTANTS

feature -- Id

	method_get: INTEGER = 0x1

	method_post: INTEGER = 0x2

	method_put: INTEGER = 0x4

	method_delete: INTEGER = 0x8

	method_head: INTEGER = 0x10

feature -- Name

	method_get_name: STRING = "GET"

	method_post_name: STRING = "POST"

	method_put_name: STRING = "PUT"

	method_delete_name: STRING = "DELETE"

	method_head_name: STRING = "HEAD"

	method_empty_name: STRING = ""

feature -- Query

	method_id (a_id: STRING): INTEGER
		local
			s: STRING
		do
			s := a_id.as_lower
			if s.same_string (method_get_name) then
				Result := method_get
			elseif s.same_string (method_post_name) then
				Result := method_post
			elseif s.same_string (method_put_name) then
				Result := method_put
			elseif s.same_string (method_delete_name) then
				Result := method_delete
			elseif s.same_string (method_head_name) then
				Result := method_head
			end
		end

	method_name (a_id: INTEGER): STRING
		do
			inspect a_id
			when method_get then Result := method_get_name
			when method_post then Result := method_post_name
			when method_put then Result := method_put_name
			when method_delete then Result := method_delete_name
			when method_head then Result := method_head_name
			else Result := method_empty_name
			end
		ensure
			result_is_upper_case: Result /= Void and then Result.as_upper ~ Result
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
