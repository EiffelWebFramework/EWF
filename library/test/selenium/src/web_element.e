note
	description: "An object in the WebDriver API that represents a DOM element on the page."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEB_ELEMENT
create
		make
feature
		make ( an_element : STRING_32)
			do
				set_element (an_element)
			end
feature -- Access
	element : STRING_32
		--The opaque ID assigned to the element by the server.
		--This ID should be used in all subsequent commands issued against the element.

feature -- Change Element
	set_element (an_element : STRING_32)
		do
			element := an_element
		end
end
