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
			redefine
				is_equal
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
feature -- Comparison
	is_equal (other: like Current): BOOLEAN is
			-- Is JSON_STRING  made of same character sequence as `other'
			-- (possibly with a different capacity)?
		do
			Result:= Current.to_json.is_equal (other.to_json)
		end

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
end
