note
	description: "Objects used to locate elements within a document"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SE_BY
inherit
	JSON_HELPER
	SE_LOCATOR_STRATEGY_CONSTANTS

create default_create

feature -- Access
	id (an_id : STRING_32; value : STRING_32 ) : STRING_32
			-- return a STRING representing a JSON
			-- with strategy by `id' and value `value'
			--	{ "using" : "id", "value":value }
		do
			create Result.make_from_string (json_template)
			Result.replace_substring_all ("$using", se_id)
			Result.replace_substring_all ("$value", value)
		ensure
			has_id_strategy : has_correct_stategy (Result, se_id)
		end

	name (an_id : STRING_32; value : STRING_32 ) : STRING_32
			-- return a STRING representing a JSON
			-- with strategy by `name' and value `value'
			--	{ "using" : "name", "value":value }
		do
			create Result.make_from_string (json_template)
			Result.replace_substring_all ("$using", se_name)
			Result.replace_substring_all ("$value", value)
		ensure
			has_name_strategy : has_correct_stategy (Result, se_name)
		end

	class_name (an_id : STRING_32; value : STRING_32 ) : STRING_32
			-- return a STRING representing a JSON
			-- with strategy by `class name' and value `value'
			--	{ "using" : "class name", "value":value }
		do
			create Result.make_from_string (json_template)
			Result.replace_substring_all ("$using", se_class_name)
			Result.replace_substring_all ("$value", value)
		ensure
			has_class_name_strategy : has_correct_stategy (Result, se_class_name)
		end


	css_selector (an_id : STRING_32; value : STRING_32 ) : STRING_32
			-- return a STRING representing a JSON
			-- with strategy by `css selector' and value `value'
			--	{ "using" : "css selector", "value":value }
		do
			create Result.make_from_string (json_template)
			Result.replace_substring_all ("$using", se_css_selector)
			Result.replace_substring_all ("$value", value)
		ensure
			has_css_selector_strategy : has_correct_stategy (Result, se_css_selector)
		end

	link_text (an_id : STRING_32; value : STRING_32 ) : STRING_32
			-- return a STRING representing a JSON
			-- with strategy by `link text' and value `value'
			--	{ "using" : "link text", "value":value }
		do
			create Result.make_from_string (json_template)
			Result.replace_substring_all ("$using", se_link_text)
			Result.replace_substring_all ("$value", value)
		ensure
			has_link_text_strategy : has_correct_stategy (Result, se_link_text)
		end


	partial_link_text (an_id : STRING_32; value : STRING_32 ) : STRING_32
			-- return a STRING representing a JSON
			-- with strategy by `partial link text' and value `value'
			--	{ "using" : "partial link text", "value":value }
		do
			create Result.make_from_string (json_template)
			Result.replace_substring_all ("$using", se_partial_link_text)
			Result.replace_substring_all ("$value", value)
		ensure
			has_partial_link_text_strategy : has_correct_stategy (Result, se_partial_link_text)
		end

	tag_name (an_id : STRING_32; value : STRING_32 ) : STRING_32
			-- return a STRING representing a JSON
			-- with strategy by `tag name' and value `value'
			--	{ "using" : "tag name", "value":value }
		do
			create Result.make_from_string (json_template)
			Result.replace_substring_all ("$using", se_tag_name)
			Result.replace_substring_all ("$value", value)
		ensure
			has_tag_name_strategy : has_correct_stategy (Result, se_tag_name)
		end


	xpath (an_id : STRING_32; value : STRING_32 ) : STRING_32
			-- return a STRING representing a JSON
			-- with strategy by `xpath' and value `value'
			--	{ "using" : "xpath", "value":value }
		do
			create Result.make_from_string (json_template)
			Result.replace_substring_all ("$using", se_xpath)
			Result.replace_substring_all ("$value", value)
		ensure
			has_xpath_strategy : has_correct_stategy (Result, se_xpath)
		end


feature -- Query
	has_correct_stategy (data: STRING_32; strategy : STRING_32) : BOOLEAN
		do
			if attached {JSON_OBJECT} string_to_json(data) as l_json then
				if attached l_json.item ("using") as l_using then
					Result := (l_using.representation).is_case_insensitive_equal_general ("%""+strategy+"%"")
				end
			end
		end


	is_valid_strategy (data : STRING_32) : BOOLEAN
		-- if data is using on of the following strategies
		--		class name
		--		css selector
		--		id	 				
		--		name	 			
		--		link text	 		
		--		partial link text	
		--		tag name	 		
		--		xpath
		-- return True in othercase False
		do
			Result := has_correct_stategy (data, se_class_name) or else
					has_correct_stategy (data, se_css_selector) or else
					has_correct_stategy (data, se_id) or else
					has_correct_stategy (data, se_link_text) or else
					has_correct_stategy (data, se_name) or else
					has_correct_stategy (data, se_partial_link_text) or else
					has_correct_stategy (data, se_tag_name) or else
					has_correct_stategy (data, se_xpath)
		end


feature {NONE} -- Implementation
	json_template : String = "[
				{"using" :"$using",
				"value" : "$value"}
			]"
end
