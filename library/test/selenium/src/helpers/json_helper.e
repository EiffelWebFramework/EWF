note
	description: "Summary description for {JSON_HELPER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JSON_HELPER
inherit

	SHARED_EJSON

feature -- Access
	to_json (an_object : ANY) :detachable JSON_VALUE
		local
			parser: JSON_PARSER
		do
			initialize_converters (json)
			if  attached json.value (an_object) as lv then
				Result := lv
			end
		end

	string_to_json ( str: STRING_32): detachable JSON_VALUE
		local
			parser: JSON_PARSER
		do
			initialize_converters (json)
			create parser.make_parser (str)
			if attached parser.parse as st and parser.is_parsed then
				Result := st
			end
		end

	json_to_se_status (post: STRING_32): detachable SE_STATUS
		local
			parser: JSON_PARSER
		do
			initialize_converters (json)
			create parser.make_parser (post)
			if attached parser.parse_object as st and parser.is_parsed then
				if attached {SE_STATUS} json.object (st, "SE_STATUS") as l_status then
					Result := l_status
				end
			end
		end

	json_to_se_capabilities (post: STRING_32): detachable SE_CAPABILITIES
		local
			parser: JSON_PARSER
		do
			initialize_converters (json)
			create parser.make_parser (post)
			if attached parser.parse_object as st and parser.is_parsed then
				if attached {SE_CAPABILITIES} json.object (st, "SE_CAPABILITIES") as l_capabilities then
					Result := l_capabilities
				end
			end
		end

	initialize_converters (j: like json)
			-- Initialize json converters
		do
			j.add_converter (create {SE_STATUS_JSON_CONVERTER}.make)
			j.add_converter (create {SE_BUILD_VALUE_JSON_CONVERTER}.make)
			j.add_converter (create {SE_JAVA_VALUE_JSON_CONVERTER}.make)
			j.add_converter (create {SE_OS_VALUE_JSON_CONVERTER}.make)
			j.add_converter (create {SE_STATUS_VALUE_JSON_CONVERTER}.make)
			j.add_converter (create {SE_CAPABILITIES_JSON_CONVERTER}.make)
			j.add_converter (create {SE_RESPONSE_JSON_CONVERTER}.make)
			j.add_converter (create {SE_TIMEOUT_TYPE_JSON_CONVERTER}.make)
		end
end
