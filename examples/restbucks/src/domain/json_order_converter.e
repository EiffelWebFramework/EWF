note
	description: "Summary description for {JSON_ORDER_CONVERTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JSON_ORDER_CONVERTER
inherit
	JSON_CONVERTER
create
	make
feature -- Initialization
	make
		do
			create object.make ("","","")
		end
feature	 -- Access
	 object : ORDER


	 value : detachable JSON_OBJECT
feature -- Conversion

	from_json (j: attached  like value): detachable like object
            -- Convert from JSON value. Returns Void if unable to convert
       local
            lstr1, lstr2, lstr3 : detachable STRING_32
            q: detachable INTEGER_8
            o: ORDER
            i : ITEM
            l_val : detachable JSON_ARRAY
            l_array : detachable ARRAYED_LIST[JSON_VALUE]
            jv : detachable JSON_OBJECT
            is_valid_from_json : BOOLEAN
        do
            is_valid_from_json := True
            lstr1 ?= json.object (j.item (id_key), Void)
            lstr2 ?= json.object (j.item (location_key), Void)
            lstr3 ?= json.object (j.item (status_key), Void)
            l_val ?= j.item (items_key)

         	create o.make (lstr1, lstr2, lstr3)

			if l_val /= void then
				l_array := l_val.array_representation
				from
					l_array.start
				until
					l_array.after
				loop
					jv ?= l_array.item_for_iteration
					if jv /= Void then
						lstr1 ?= json.object (jv.item (name_key), Void)
    	        		lstr2 ?= json.object (jv.item (size_key), Void)
    	        		lstr3 ?= json.object (jv.item (option_key), Void)
						q     ?= json.object (jv.item (quantity_key),Void)
						if lstr1/= Void and then lstr2 /= Void and then lstr3 /= Void then
							if is_valid_item_customization(lstr1,lstr2,lstr3,q) then
								create i.make (lstr1, lstr2,lstr3, q)
								o.add_item (i)
							else
								is_valid_from_json := false
							end
						else
							is_valid_from_json := false
						end
					end

					l_array.forth
				end
			end
			if not is_valid_from_json or o.items.is_empty then
				Result := Void
			else
				Result := o
			end

	    end

    to_json (o: like object): like value
            -- Convert to JSON value
        local
        	ja : JSON_ARRAY
        	i : ITEM
        	jv: JSON_OBJECT
        do
        	create Result.make
            Result.put (json.value (o.id), id_key)
            Result.put (json.value (o.location),location_key)
			Result.put (json.value (o.status),status_key)
            from
            	create ja.make_array
            	o.items.start
            until
            	o.items.after
            loop
            	i := o.items.item_for_iteration
            	create jv.make
            	jv.put (json.value (i.name), name_key)
            	jv.put (json.value (i.size),size_key)
            	jv.put (json.value (i.quantity), quantity_key)
            	jv.put (json.value (i.option), option_key)
            	ja.add (jv)
            	o.items.forth
            end
            Result.put(ja,items_key)
        end

 feature {NONE} -- Implementation
	id_key: JSON_STRING
        once
            create Result.make_json ("id")
        end

	location_key: JSON_STRING
        once
            create Result.make_json ("location")
        end

   status_key: JSON_STRING
        once
            create Result.make_json ("status")
        end

    items_key : JSON_STRING
	 	once
    		create Result.make_json ("items")
    	end


	name_key : JSON_STRING

    	once
    		create Result.make_json ("name")
    	end

    size_key : JSON_STRING

    	once
    		create Result.make_json ("size")
    	end

	quantity_key : JSON_STRING

    	once
    		create Result.make_json ("quantity")
    	end


    option_key : JSON_STRING

    	once
    		create Result.make_json ("option")
    	end
feature -- Validation

	is_valid_item_customization ( name :  STRING_32; size: STRING_32; option :  STRING_32; quantity :  INTEGER_8  ) : BOOLEAN
		local
			ic : ITEM_CONSTANTS
		do
				create ic
				Result := ic.is_valid_coffee_type (name) and ic.is_valid_milk_type (option) and ic.is_valid_size_option (size) and quantity > 0
		end

end
