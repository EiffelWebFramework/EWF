note
	description: "Summary description for {ORDER_JSON_SERIALIZATION}."
	date: "$Date$"
	revision: "$Revision$"

class
	ORDER_JSON_SERIALIZATION

inherit
	JSON_SERIALIZER

	JSON_DESERIALIZER

feature -- Conversion

	to_json (obj: detachable ANY; ctx: JSON_SERIALIZER_CONTEXT): JSON_VALUE
			-- JSON value representing the JSON serialization of Eiffel value `obj', in the eventual context `ctx'.
		local
			j_order: JSON_OBJECT
			j_item: JSON_OBJECT
			ja: JSON_ARRAY
		do
			has_error := False
			if attached {ORDER} obj as l_order then
				create j_order.make_with_capacity (4)
				Result := j_order
				j_order.put_string (l_order.id, id_key)
				if attached l_order.location as loc then
					j_order.put_string (loc, location_key)
				end
				j_order.put_string (l_order.status, status_key)
				if attached l_order.items as l_items and then not l_items.is_empty then
					create ja.make (l_items.count)
					j_order.put (ja, items_key)
					across
						l_items as ic
					loop
						if attached {ORDER_ITEM} ic.item as l_item then
							create j_item.make_with_capacity (4)
							j_item.put_string (l_item.name, name_key)
							j_item.put_string (l_item.size, size_key)
							j_item.put_integer (l_item.quantity, quantity_key)
							j_item.put_string (l_item.option, option_key)
							ja.extend (j_item)
						end
					end
				end
			else
				create {JSON_NULL} Result
				has_error := True
			end
		end

	from_json (a_json: detachable JSON_VALUE; ctx: JSON_DESERIALIZER_CONTEXT; a_type: detachable TYPE [detachable ANY]): detachable ORDER
			-- <Precursor/>.
		local
			l_status: detachable STRING_32
			q: NATURAL_8
			is_valid_from_json: BOOLEAN
			l_name, l_size, l_option: detachable READABLE_STRING_32
		do
			has_error := False
			is_valid_from_json := True
			if attached {JSON_OBJECT} a_json as jobj then
					-- Either new order (i.e no id and no status)
					-- or an existing order with `id` and `status` (could be Void, thus use default).
				if attached {JSON_STRING} jobj.item (status_key) as j_status then
					l_status := j_status.unescaped_string_32
				end
				if
					attached {JSON_STRING} jobj.item (id_key) as j_id
				then
						-- Note: the id has to be valid string 8 value!
					create Result.make (j_id.unescaped_string_8, l_status)
				elseif attached {JSON_NUMBER} jobj.item (id_key) as j_id then
						-- Be flexible and accept json number as id.
					create Result.make (j_id.integer_64_item.out, l_status)
				else
					create Result.make_empty
					if l_status /= Void then
						Result.set_status (l_status)
					end
				end
				if attached {JSON_STRING} jobj.item (location_key) as j_location then
					Result.set_location (j_location.unescaped_string_32)
				end
				if attached {JSON_ARRAY} jobj.item (items_key) as j_items then
					across
						j_items as ic
					loop
						if attached {JSON_OBJECT} ic.item as j_item then
							if
								attached {JSON_NUMBER} j_item.item (quantity_key) as j_quantity and then
								j_quantity.integer_64_item < {NATURAL_8}.Max_value
							then
								q := j_quantity.integer_64_item.to_natural_8
							else
								q := 0
							end
							if
								attached {JSON_STRING} j_item.item (name_key) as j_name and then
								attached {JSON_STRING} j_item.item (size_key) as j_size and then
								attached {JSON_STRING} j_item.item (option_key) as j_option
							then
								l_name := j_name.unescaped_string_32
								l_size := j_size.unescaped_string_32
								l_option := j_option.unescaped_string_32
								if is_valid_item_customization (l_name, l_size, l_option, q) then
									Result.add_item (create {ORDER_ITEM}.make (l_name, l_size, l_option, q))
								else
									is_valid_from_json := False
								end
							else
								is_valid_from_json := False
							end
						end
					end
				end
				if not is_valid_from_json or Result.items.is_empty then
					Result := Void
				end
			else
				is_valid_from_json := a_json = Void or else attached {JSON_NULL} a_json
				Result := Void
			end
			has_error := not is_valid_from_json
		end

	has_error: BOOLEAN
			-- Error occurred during last `from_json` or `to_json` execution.

feature {NONE} -- Implementation

	id_key: STRING = "id"

	location_key: STRING = "location"

	status_key: STRING = "status"

	items_key: STRING = "items"

	name_key: STRING = "name"

	size_key: STRING = "size"

	quantity_key: STRING = "quantity"

	option_key: STRING = "option"

feature -- Validation

	is_valid_item_customization (name: READABLE_STRING_GENERAL; size: READABLE_STRING_GENERAL; option: READABLE_STRING_GENERAL; quantity: NATURAL_8): BOOLEAN
		local
			ic: ORDER_ITEM_VALIDATION
		do
			create ic
			Result := 	ic.is_valid_coffee_type (name) and
						ic.is_valid_milk_type (option) and
						ic.is_valid_size_option (size) and
						quantity > 0
		end

note
	copyright: "2011-2017, Javier Velilla and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
