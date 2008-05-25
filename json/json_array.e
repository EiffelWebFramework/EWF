indexing
	description: "[
			JSON_ARRAY represent an array in JSON.
			An array in JSON is an ordered set of names.
			Examples
			array
				[]
				[elements]
			]"

	author: "Javier Velilla"
	date: "$Date$"
	revision: "$Revision$"

class
	JSON_ARRAY
	inherit
	JSON_VALUE

create
	make_array

feature -- Initialization
	make_array is
			--
			do
				create values.make (10)
			end

feature -- Access
	i_th alias "[]", infix "@" (i: INTEGER):JSON_VALUE is
			-- Item at `i'-th position
		do
			Result := values.i_th (i)
		end

feature -- Mesurement
	count:INTEGER is
			--
		do
			Result:=values.count
		end

feature -- Status report
	valid_index (i: INTEGER): BOOLEAN is
			-- Is `i' a valid index?
		do
			Result := (1 <= i) and (i <= count)
		end

feature -- Change Element
	add(value:JSON_VALUE) is
			require
			   not_null:value /= void
			local
			 l_json_value:JSON_VALUE
			do
				values.extend(value)
			ensure
				has_new_value:old values.count + 1 = values.count
			end

feature -- Report
	to_json:STRING is
			--Printable json representation
			-- [] or [elements]
			local
				value:JSON_VALUE
			do
				create Result.make_empty
				Result.append("[")
				from
					values.start
				until
					values.off
				loop
					value:=values.item
					Result.append(value.to_json)
					values.forth
					if not values.after then
						Result.append(",")
					end
				end
				Result.append("]")
			end

	hash_code:INTEGER is
				--
				do
				   from
				   	values.start
				   	Result:=values.item.hash_code
				   until
				   	values.off
				   loop
				   	Result:= ((Result \\ 8388593) |<< 8) + values.item.hash_code
				   	values.forth
				   end
				   Result := Result \\ values.count

				end
feature {NONE} --Implementation
	values:ARRAYED_LIST[JSON_VALUE]


end
