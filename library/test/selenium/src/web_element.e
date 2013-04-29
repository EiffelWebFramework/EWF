note
	description: "An object in the WebDriver API that represents a DOM element on the page."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEB_ELEMENT
create
		make,
		make2
feature
		make2 ( an_element : STRING_32 ; an_api : like api; a_session_id : STRING_32)
			do
				set_element (an_element)
				api := an_api
				session_id := a_session_id
			end
		make ( an_element : STRING_32)
			do
				set_element (an_element)
				create api.make
				session_id := ""
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

feature -- Web Element API
	clear
		-- Clear a TEXTAREA or text INPUT element's value.
		do
			api.clear_element (session_id, element)
		end

	click
		-- 	Click on an element.
		do
			api.element_click (session_id, element)
		end

	find_element (by : SE_BY) : detachable WEB_ELEMENT
		-- Find the first WebElement using the given method.
		do
			Result := api.search_element (session_id,"")
		end

	find_elementS (by : SE_BY) : detachable LIST[WEB_ELEMENT]
		-- Find all elements within the current context using the given mechanism.
		do
			Result := api.search_elements (session_id,"")
		end

	get_attribute (name : STRING_32) : detachable STRING_32
		-- Get the value of an element's attribute.
		do
			Result := api.element_value (session_id, element, name)
		end

	get_css_value (name : STRING_32) : detachable STRING_32
		-- Get the value of an element's attribute.
		do
			Result := api.element_css_value (session_id, element, name)
		end

	get_location : SE_POINT
		-- Determine an element's location on the page. The point (0, 0) refers to the upper-left corner of the page.
		do
			Result := api.element_location (session_id, element)
		end


	get_size : SE_DIMENSION
		-- Determine an element's size in pixels. The size will be returned as a JSON object with width and height properties.
		do
			Result := api.element_size (session_id, element)
		end

	get_tag_name : detachable STRING_32
		-- The element's tag name, as a lowercase string.
		do
			Result := api.query_by_tag_name (session_id, element)
		end


	get_text : detachable STRING_32
		-- Returns the visible text for the element.
		do
			Result :=  api.element_text (session_id, element)
		end

	is_displayed : BOOLEAN
		-- Determine if an element is currently displayed.
		do
			Result := api.is_displayed (session_id, element)
		end

	is_enabled : BOOLEAN
		-- Determine if an element is currently enabled.
		do
			Result := api.is_enabled (session_id, element)
		end

	is_selected : BOOLEAN
		-- Determine if an OPTION element, or an INPUT element of type checkbox or radiobutton is currently selected.
		do
			Result := api.is_selected (session_id, element)
		end

	send_keys  (keys : ARRAY[STRING_32])
		-- Send a sequence of key strokes to an element.
		do
			api.send_event (session_id, element, keys)
		end

	submit
		-- Submit a FORM element. The submit command may also be applied to any element that is a descendant of a FORM element.
		do
			api.element_submit (session_id, element)
		end

feature {NONE} -- Implementation

	api : SE_JSON_WIRE_PROTOCOL
	session_id : STRING_32
end
