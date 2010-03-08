indexing
    description: "A JSON converter for LINKED_LIST [ANY]"
    author: "Paul Cohen"
    date: "$Date$"
    revision: "$Revision$"
    file: "$HeadURL: $"

class JSON_LINKED_LIST_CONVERTER

inherit
    JSON_CONVERTER
    
create
    make
    
feature {NONE} -- Initialization
    
    make is
        do
            create object.make
        end
        
feature -- Access

    value: JSON_ARRAY
            
    object: LINKED_LIST [ANY]
            
feature -- Conversion

    from_json (j: like value): like object is
        local
            i: INTEGER
        do
            create Result.make
            from
                i := 1
            until
                i > j.count
            loop
                Result.extend (json.object (j [i], Void))
                i := i + 1
            end
        end
        
    to_json (o: like object): like value is
        local
            c: LINKED_LIST_CURSOR [ANY]
        do
            create Result.make_array
            from
                o.start
            until
                o.after
            loop
                Result.add (json.value (o.item))
                o.forth
            end
        end
        
end -- class JSON_LINKED_LIST_CONVERTER