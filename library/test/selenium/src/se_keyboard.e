note
	description: "Objects representing basic keyboards operations"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SE_KEYBOARD

create
	make
feature {NONE} -- Initialization
	make ( a_web_driver : like driver)
			-- Create an object se_keyboard with his driver
		do
			driver := a_web_driver
		ensure
			web_driver_set : driver = a_web_driver
		end

feature --Access
	send_keys  (keys : ARRAY[STRING_32])
		do
			if attached driver.active_element as l_active_element then
				l_active_element.send_keys (keys)
			end
		end

	press_key ( key : SE_KEY_STROKE)
		local
			l_data : STRING_32
		do
			create l_data.make_from_string (json_template)
			l_data.replace_substring_all ("$value", key.key)
			l_data.replace_substring_all ("$boolean", "True")
			if attached driver.session as l_session then
				driver.api.modifier (l_session.session_id, l_data)
			end
		end

	release_key ( key : SE_KEY_STROKE)
		local
			l_data : STRING_32
		do
			create l_data.make_from_string (json_template)
			l_data.replace_substring_all ("$value", key.key)
			l_data.replace_substring_all ("$boolean", "False")
			if attached driver.session as l_session then
				driver.api.modifier (l_session.session_id, l_data )
			end
		end



feature {NONE} -- Implementation
	driver : WEB_DRIVER
		-- web_driver

	json_template : String = "[
				{"value" :"$value",
				"isdown" : $boolean}
			]"
end
