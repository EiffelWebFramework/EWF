indexing
	description: "A JSON converter"
	author: "Paul Cohen"
	date: "$Date: $"
	revision: "$Revision: $"
	file: "$HeadURL: $"

deferred class JSON_CONVERTER

inherit    
    SHARED_EJSON

feature -- Access

    value: JSON_VALUE is
            -- JSON value
        deferred
        end
        
    object: ANY is
            -- Eiffel object
        deferred
        end
            
feature -- Conversion

    from_json (j: like value): like object is
            -- Convert from JSON value. Returns Void if unable to convert
        deferred
        end
        
    to_json (o: like object): like value is
            -- Convert to JSON value
        deferred
        end

invariant
    has_eiffel_object: object /= Void -- An empty object must be created at creation time!
    
end -- class JSON_CONVERTER

