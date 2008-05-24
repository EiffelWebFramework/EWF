indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JSON_TOKENS

feature -- Access
	J_OBJECT_OPEN:CHARACTER is '{'
	J_ARRAY_OPEN:CHARACTER is '['
	J_OBJECT_CLOSE:CHARACTER is '}'
	J_ARRAY_CLOSE:CHARACTER is ']'

	J_STRING:CHARACTER is '"'
	J_PLUS:CHARACTER is '+'
	J_MINUS:CHARACTER is '-'
	J_DOT:CHARACTER is '.'

	open_tokens:ARRAY[CHARACTER] is
			-- Characters wich open a type
			once
				Result:=<<J_OBJECT_OPEN,J_ARRAY_OPEN,J_STRING,J_PLUS,J_MINUS,J_DOT>>
			end

	close_tokens:ARRAY[CHARACTER] is
			-- Characters wich close a type
			once
				Result:=<<J_OBJECT_CLOSE,J_ARRAY_CLOSE,J_STRING >>
			end

end
