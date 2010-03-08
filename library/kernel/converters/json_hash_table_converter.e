indexing 
    description: "A JSON converter for HASH_TABLE [ANY, HASHABLE]"
    author: "Paul Cohen"
    date: "$Date$"
    revision: "$Revision$"
    file: "$HeadURL: $"

class JSON_HASH_TABLE_CONVERTER

inherit
    JSON_CONVERTER
    
create
    make
    
feature {NONE} -- Initialization
    
    make is
        do
            create object.make (0)
        end
        
feature -- Access

    value: JSON_OBJECT
            
    object: HASH_TABLE [ANY, HASHABLE]
            
feature -- Conversion

    from_json (j: like value): like object is
        local
            keys: ARRAY [JSON_STRING]
            i: INTEGER
            h: HASHABLE
            a: ANY
        do
            keys := j.current_keys
            create Result.make (keys.count)
            from
                i := 1
            until
                i > keys.count
            loop
                h ?= json.object (keys [i], void)
                check h /= Void end
                a := json.object (j.item (keys [i]), Void)
                Result.put (a, h)
                i := i + 1
            end
        end
        
    to_json (o: like object): like value is
        local
            js: JSON_STRING
            jv: JSON_VALUE
            failed: BOOLEAN
        do
            create Result.make
            from
                o.start
            until
                o.after
            loop
                create js.make_json (o.key_for_iteration.out)
                jv := json.value (o.item_for_iteration)
                if jv /= Void then
                    Result.put (jv, js)
                else
                    failed := True
                end 
                o.forth
            end
            if failed then
                Result := Void
            end
        end
  
end -- class JSON_HASH_TABLE_CONVERTER