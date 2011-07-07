note

    description: "[
        A JSON_STRING represent a string in JSON.
        A string is a collection of zero or more Unicodes characters, wrapped in double
        quotes, using blackslash espaces.
        ]"

    author: "Javier Velilla"
    date: "2008/08/24"
    revision: "Revision 0.1"
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

feature {NONE} -- Initialization

    make_json (an_item: STRING)
            -- Initialize.
        require
            item_not_void: an_item /= Void
        do
            item := escaped_json_string (an_item)
        end

feature -- Access

    item: STRING
            -- Contents

    representation: STRING
        do
            Result := "%""
            Result.append (item)
            Result.append_character ('%"')
        end
        
feature -- Visitor pattern

    accept (a_visitor: JSON_VISITOR)
            -- Accept `a_visitor'.
            -- (Call `visit_json_string' procedure on `a_visitor'.)
        do
            a_visitor.visit_json_string (Current)
        end

feature -- Comparison

    is_equal (other: like Current): BOOLEAN
            -- Is JSON_STRING  made of same character sequence as `other'
            -- (possibly with a different capacity)?
        do
            Result := item.is_equal (other.item)
        end

feature -- Change Element

    append (a_string: STRING)
            -- Add an_item
        require
            a_string_not_void: a_string /= Void
        do
            item.append_string (a_string)
        end

feature -- Status report

    hash_code: INTEGER
            -- Hash code value
        do
            Result := item.hash_code
        end

feature -- Status report

    debug_output: STRING
            -- String that should be displayed in debugger to represent `Current'.
        do
            Result := item
        end

feature {NONE} -- Implementation

    escaped_json_string (s: STRING): STRING
            -- JSON string with '"' and '\' characters escaped
        require
            s_not_void: s /= Void
        do
            Result := s.twin
            Result.replace_substring_all ("\", "\\")
            Result.replace_substring_all ("%"", "\%"")
        end
    
invariant
    value_not_void: item /= Void

end
