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

feature -- Status Report

   	is_json_array:BOOLEAN is
		-- Does `Current' represent a JSON_ARRAY?
		do
			if generating_type.is_equal ("JSON_ARRAY") then
    			Result := true
			end
		end

	is_json_string:BOOLEAN is
		-- Does `Current' represent a JSON_STRING?
		do
		   if generating_type.is_equal ("JSON_STRING") then
    			Result := true
		   end

		end

	is_json_object:BOOLEAN is
		-- Does `Current' represent a JSON_OBJECT?
		do

		  if generating_type.is_equal ("JSON_OBJECT") then
    			Result := true
		  end

		end

	is_json_number:BOOLEAN is
		-- Does 'Current' represent a JSON_NUMBER?
		do
		  if generating_type.is_equal ("JSON_NUMBER") then
    			Result := true
		  end
		end

	is_json_boolean:BOOLEAN is
		-- Does 'Current' represent a JSON_BOOLEAN?
		do
			if generating_type.is_equal ("JSON_BOOLEAN") then
    			Result := true
		 	end
		end

	is_json_null:BOOLEAN is
		-- Does 'Current' represent a JSON_NULL?
		do
			if generating_type.is_equal ("JSON_NULL") then
    			Result := true
		  	end

		end

feature -- Conversion

	to_json_array:JSON_ARRAY is
		-- Convert `Current' as a JSON_ARRAY.
		require
			is_a_json_array:is_json_array
		do
			Result ?= Current
		end

	to_json_string:JSON_STRING is
		-- Convert `Current' as a JSON_STRING.
		require
			is_a_json_string: is_json_string
		do
			Result ?= Current
		end

	to_json_object:JSON_OBJECT is
		-- Convert 'Current' as a JSON_OBJECT
		require
				is_a_json_object: is_json_object
		do
			Result?=Current
		end

	to_json_number:JSON_NUMBER is
		-- Convert 'Current' as a JSON_NUMBER
		require
			is_a_json_number:is_json_number
		do
			Result ?= Current
		end

	to_json_boolean:JSON_BOOLEAN is
		-- Convert 'Current' as a JSON_BOOLEAN
		require
			is_a_json_boolean:is_json_boolean
		do
			Result ?= Current
		end

	to_json_null:JSON_NULL is
		-- Convert 'Current' as a JSON_NULL
		require
			is_a_json_null:is_json_null
		do
			Result ?= Current
		end


end
