indexing
	description: ""
	author: "jvelilla"
	date: "2008/08/24"
	revision: "0.1"

class
	JSON_TOKENS

feature -- Access

	j_OBJECT_OPEN: CHARACTER is '{'
	j_ARRAY_OPEN: CHARACTER is '['
	j_OBJECT_CLOSE: CHARACTER is '}'
	j_ARRAY_CLOSE: CHARACTER is ']'

	j_STRING: CHARACTER is '"'
	j_PLUS: CHARACTER is '+'
	j_MINUS: CHARACTER is '-'
	j_DOT: CHARACTER is '.'

feature -- Status report

	is_open_token (c: CHARACTER): BOOLEAN is
			-- Characters which open a type	
		do
			inspect c
			when j_OBJECT_OPEN, j_ARRAY_OPEN, j_STRING, j_PLUS, j_MINUS, j_DOT then
				Result := True
			else

			end
		end

	is_close_token (c: CHARACTER): BOOLEAN is
			-- Characters which close a type	
		do
			inspect c
			when j_OBJECT_CLOSE, j_ARRAY_CLOSE, j_STRING then
				Result := True
			else

			end
		end

	is_special_character (c: CHARACTER): BOOLEAN is
			-- Control Characters
			-- 	%F  	Form feed
			-- 	%H  	backslasH
			--  %N  	Newline
			--  %R  	carriage Return
			--  %T  	horizontal Tab
			--  %B  	Backspace
		    --  /       Solidus
		    --  "       Quotation	
		do
			inspect c
			when '%F', '%H', '%N', '%R', '%T', '%B', '/', '"' then
				Result := True
			else

			end
		end

   is_special_control (c: CHARACTER): BOOLEAN is
           --Control Characters
           -- \b\f\n\r\t
		do
			inspect c
			when 'b', 'f', 'n', 'r', 't' then
				Result := True
			else

			end
		end

end
