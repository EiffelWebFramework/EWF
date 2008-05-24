indexing
	description:"[
			A JSON_STRING represent a string in JSON.
			A string is a collection of zero or more Unicodes characters, wrapped in double
			quotes, using blackslash espaces.
	]"

	author: "Javier Velilla"
	date: "$Date$"
	revision: "$Revision$"
	license:"MIT (see http://www.opensource.org/licenses/mit-license.php)"

class
	JSON_STRING
	inherit
		JSON_VALUE
			rename
				is_equal as is_equal_json
			end

	create
		make_json
feature -- Initialization
	make_json(value:STRING) is
			--
			do
				create buffer.make(256)
				buffer.append (value)
			end


feature -- Access

feature -- Change Element
	append(value:STRING)is
			--
			do
				buffer.append (value)
			end


feature -- Status report
	to_json:STRING is
			--
			do
				create	Result.make_empty
				Result.append ("%"")
				Result.append (buffer)
				Result.append ("%"")
			end

	hash_code:INTEGER is
			--
			do
				Result:= buffer.hash_code + buffer.count
			end

feature {NONE} -- Implementation
	buffer:STRING
invariant
	invariant_clause: True -- Your invariant here

end
