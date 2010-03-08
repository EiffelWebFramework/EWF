indexing
    description: "Core factory class for creating JSON objects and corresponding Eiffel objects."
    author: "Paul Cohen"
    date: "$Date: $"
    revision: "$Revision: $"
    file: "$HeadURL: $"

class EJSON

inherit
    {NONE} KL_EXCEPTIONS
        
feature -- Access
        
    value (an_object: ?ANY): JSON_VALUE is
            -- JSON value from Eiffel object. Raises an "eJSON exception" if 
            -- unable to convert value.
        local
            b: BOOLEAN
            i: INTEGER
            i8: INTEGER_8
            i16: INTEGER_16
            i32: INTEGER_32
            i64: INTEGER_64
            n8: NATURAL_8
            n16: NATURAL_16
            n32: NATURAL_32
            n64: NATURAL_64
            r32: REAL_32
            r64: REAL_64
            a: ARRAY [ANY]
            c: CHARACTER
            s8: STRING_8
            ucs: UC_STRING
            ja: JSON_ARRAY
            jc: JSON_CONVERTER
        do
            -- Try to convert from basic Eiffel types. Note that we check with
            -- `conforms_to' since the client may have subclassed the base class
            -- that these basic types are derived from.
            if an_object = Void then
                create {JSON_NULL} Result
            elseif an_object.conforms_to (a_boolean) then
                b ?= an_object
                create {JSON_BOOLEAN} Result.make_boolean (b)
            elseif an_object.conforms_to (an_integer_8) then
                i8 ?= an_object
                create {JSON_NUMBER} Result.make_integer (i8)
            elseif an_object.conforms_to (an_integer_16) then
                i16 ?= an_object
                create {JSON_NUMBER} Result.make_integer (i16)
            elseif an_object.conforms_to (an_integer_32) then
                i32 ?= an_object
                create {JSON_NUMBER} Result.make_integer (i32)
            elseif an_object.conforms_to (an_integer_64) then
                i64 ?= an_object
                create {JSON_NUMBER} Result.make_integer (i64)
            elseif an_object.conforms_to (a_natural_8) then
                n8 ?= an_object
                create {JSON_NUMBER} Result.make_natural (n8)
            elseif an_object.conforms_to (a_natural_16) then
                n16 ?= an_object
                create {JSON_NUMBER} Result.make_natural (n16)
            elseif an_object.conforms_to (a_natural_32) then
                n32 ?= an_object
                create {JSON_NUMBER} Result.make_natural (n32)
            elseif an_object.conforms_to (a_natural_64) then
                n64 ?= an_object
                create {JSON_NUMBER} Result.make_natural (n64)
            elseif an_object.conforms_to (a_real_32) then
                r32 ?= an_object
                create {JSON_NUMBER} Result.make_real (r32)
            elseif an_object.conforms_to (a_real_64) then
                r64 ?= an_object
                create {JSON_NUMBER} Result.make_real (r64)
            elseif an_object.conforms_to (an_array) then
                a ?= an_object
                create ja.make_array
                from
                    i := a.lower
                until
                    i > a.upper
                loop
                    ja.add (value (a @ i))
                    i := i + 1
                end
                Result := ja
            elseif an_object.conforms_to (a_character) then
                c ?= an_object
                create {JSON_STRING} Result.make_json (c.out)
            elseif an_object.conforms_to (a_uc_string) then
                ucs ?= an_object
                create {JSON_STRING} Result.make_json (ucs.to_utf8)
            elseif an_object.conforms_to (a_string_8) then
                s8 ?= an_object
                create {JSON_STRING} Result.make_json (s8)
            end
            
            if Result = Void then
                -- Now check the converters
                jc := converter_for (an_object)
                if jc /= Void then
                    Result := jc.to_json (an_object)
                else
                    raise (exception_failed_to_convert_to_json (an_object))
                end
            end
        end

    object (a_value: JSON_VALUE; base_class: ?STRING): ANY is
            -- Eiffel object from JSON value. If `base_class' /= Void an eiffel
            -- object based on `base_class' will be returned. Raises an "eJSON 
            -- exception" if unable to convert value.
        require
            a_value_not_void: a_value /= Void
        local
            jc: JSON_CONVERTER
            jb: JSON_BOOLEAN
            jn: JSON_NUMBER
            js: JSON_STRING
            ja: JSON_ARRAY
            jo: JSON_OBJECT
            i: INTEGER
            ll: LINKED_LIST [ANY]
            t: HASH_TABLE [ANY, UC_STRING]
            keys: ARRAY [JSON_STRING]
            ucs: UC_STRING
        do
            if base_class = Void then
                if a_value.generator.is_equal ("JSON_NULL") then
                    Result := Void
                elseif a_value.generator.is_equal ("JSON_BOOLEAN") then
                    jb ?= a_value
                    check jb /= Void end
                    Result := jb.item
                elseif a_value.generator.is_equal ("JSON_NUMBER") then
                    jn ?= a_value
                    check jn /= Void end
                    if jn.item.is_integer_8 then
                        Result := jn.item.to_integer_8
                    elseif jn.item.is_integer_16 then
                        Result := jn.item.to_integer_16
                    elseif jn.item.is_integer_32 then
                        Result := jn.item.to_integer_32
                    elseif jn.item.is_integer_64 then
                        Result := jn.item.to_integer_64
                    elseif jn.item.is_natural_64 then
                        Result := jn.item.to_natural_64
                    elseif jn.item.is_double then
                        Result := jn.item.to_double
                    end
                elseif a_value.generator.is_equal ("JSON_STRING") then
                    js ?= a_value
                    check js /= Void end
                    create ucs.make_from_string (js.item)
                    Result := ucs
                elseif a_value.generator.is_equal ("JSON_ARRAY") then
                    ja ?= a_value
                    check ja /= Void end
                    from
                        create ll.make ()
                        i := 1
                    until 
                        i > ja.count
                    loop
                        ll.extend (object (ja [i], Void))
                        i := i + 1
                    end
                    Result := ll
                elseif a_value.generator.is_equal ("JSON_OBJECT") then
                    jo ?= a_value
                    check jo /= Void end
                    keys := jo.current_keys
                    create t.make (keys.count)
                    from
                        i := keys.lower
                    until
                        i > keys.upper
                    loop
                        ucs ?= object (keys [i], Void)
                        check ucs /= Void end
                        t.put (object (jo.item (keys [i]), Void), ucs)
                        i := i + 1
                    end
                    Result := t
                end
            else
                if converters.has (base_class) then
                    jc := converters @ base_class
                    Result := jc.from_json (a_value)
                else
                    raise (exception_failed_to_convert_to_eiffel (a_value, base_class))
                end
            end
        end

    object_from_json (json: STRING; base_class: ?STRING): ANY is
            -- Eiffel object from JSON representation. If `base_class' /= Void an 
            -- Eiffel object based on `base_class' will be returned. Raises an 
            -- "eJSON exception" if unable to convert value.
        require
            json_not_void: json /= Void
        local
            jv: JSON_VALUE
        do
            json_parser.set_representation (json)
            jv := json_parser.parse
            Result := object (jv, base_class)
        end

    converter_for (an_object: ANY): JSON_CONVERTER is
            -- Converter for objects. Returns Void if none found.
        require
            an_object_not_void: an_object /= Void
        do
            if converters.has (an_object.generator) then
                Result := converters @ an_object.generator
            end
        end
        
    json_reference (s: STRING): JSON_OBJECT is
            -- A JSON (Dojo style) reference object using `s' as the
            -- reference value. The caller is responsable for ensuring
            -- the validity of `s' as a json reference.
        require
            s_not_void: s /= Void
        local
            js_key, js_value: JSON_STRING
        do
            create Result.make
            create js_key.make_json ("$ref")
            create js_value.make_json (s)
            Result.put (js_value, js_key)
        end
    
    json_references (l: DS_LIST [STRING]): JSON_ARRAY is
            -- A JSON array of JSON (Dojo style) reference objects using the 
            -- strings in `l' as reference values. The caller is responsable 
            -- for ensuring the validity of all strings in `l' as json 
            -- references.
        require
            l_not_void: l /= Void
        local
            c: DS_LIST_CURSOR [STRING]
        do
            create Result.make_array
            from
                c := l.new_cursor
                c.start
            until
                c.after
            loop
                Result.add (json_reference (c.item))
                c.forth
            end
        end
        
feature -- Change

    add_converter (jc: JSON_CONVERTER) is
            -- Add the converter `jc'.
        require
            jc_not_void: jc /= Void
        do
            converters.force (jc, jc.object.generator)
        ensure
            has_converter: converter_for (jc.object) /= Void
        end

feature {NONE} -- Implementation

    converters: DS_HASH_TABLE [JSON_CONVERTER, STRING] is
            -- Converters hashed by generator (base class)
        once
            create Result.make (10)
        end

feature {NONE} -- Implementation (Exceptions)

    exception_prefix: STRING is "eJSON exception: "
    
    exception_failed_to_convert_to_eiffel (a_value: JSON_VALUE; base_class: ?STRING): STRING is
            -- Exception message for failing to convert a JSON_VALUE to an instance of `a'.
        do
            Result := exception_prefix + "Failed to convert JSON_VALUE to an Eiffel object: " + a_value.generator
            if base_class /= Void then
                Result.append (" -> " + base_class)
            end
        end

    exception_failed_to_convert_to_json (an_object: ?ANY): STRING is
            -- Exception message for failing to convert `a' to a JSON_VALUE.
        do
            Result := exception_prefix + "Failed to convert Eiffel object to a JSON_VALUE: " + an_object.generator
        end

feature {NONE} -- Implementation (JSON parser)

    json_parser: JSON_PARSER is
        once
            create Result.make_parser ("")
        end

feature {NONE} -- Implementation (Basic Eiffel objects)

    a_boolean: BOOLEAN
    
    an_integer_8: INTEGER_8

    an_integer_16: INTEGER_16

    an_integer_32: INTEGER_32

    an_integer_64: INTEGER_64

    a_natural_8: NATURAL_8

    a_natural_16: NATURAL_16

    a_natural_32: NATURAL_32

    a_natural_64: NATURAL_64
    
    a_real_32: REAL_32

    a_real_64: REAL_64

    an_array: ARRAY [ANY] is
        once
            Result := <<>>
        end
    
    a_character: CHARACTER
    
    a_string_8: STRING_8 is
        once
            Result := ""
        end

    a_uc_string: UC_STRING is
        once
            create Result.make_from_string ("")
        end
        
end -- class EJSON