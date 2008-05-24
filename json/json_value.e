indexing
	description:"[
			JSON_VALUE represent a value in JSON. 
					A value can be
						* a string in double quotes
						* a number
						* boolean value(true, false )
						* null
						* an object
						* an array


		]"
	author: "Javier Velilla"
	date: "2008/05/19"
	revision: "Revision 0.1"
	license:"MIT (see http://www.opensource.org/licenses/mit-license.php)"


deferred class
	JSON_VALUE
	inherit
		HASHABLE

feature -- Access
	to_json:STRING is
			-- Generate the JSON String for this value object
			-- return a correct JSON-STRING
		deferred
		end

end
