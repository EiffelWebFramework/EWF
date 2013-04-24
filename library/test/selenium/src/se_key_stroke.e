note
	description: "Summary description for {SE_KEY_STROKE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SE_KEY_STROKE

feature -- Access

	Null_key: STRING_32 = "\uE000"

	Cancel_key: STRING_32 = "\uE001"

	Help_key: STRING_32 = "\uE002"

	Backspace_key: STRING_32 = "\uE003"

	Tab_key: STRING_32 = "\uE004"

	Clear_key: STRING_32 = "\uE005"

	Return_key: STRING_32 = "\uE006"

	Enter_key: STRING_32 = "\uE007"

	Shift_key: STRING_32 = "\uE008"

	Control_key: STRING_32 = "\uE009"

	Alt_key: STRING_32 = "\uE00A"

	Pause_key: STRING_32 = "\uE00B"

	Escape_key: STRING_32 = "\uE00C"

	Space_key: STRING_32 = "\uE00D"

	PageUp_key: STRING_32 = "\uE00E"

	PageDown_key: STRING_32 = "\uE00F"

	End_key: STRING_32 = "\uE010"

	Home_key: STRING_32 = "\uE011"

	LeftArrow_key: STRING_32 = "\uE012"

	UpArrow_key: STRING_32 = "\uE013"

	RightArrow_key: STRING_32 = "\uE014"

	DownArrow_key: STRING_32 = "\uE015"

	Insert_key: STRING_32 = "\uE016"

	Delete_key: STRING_32 = "\uE017"

	Semicolon_key: STRING_32 = "\uE018"

	Equals_key: STRING_32 = "\uE019"

	Numpad0_key: STRING_32 = "\uE01A"

	Numpad1_key: STRING_32 = "\uE01B"

	Numpad2_key: STRING_32 = "\uE01C"

	Numpad3_key: STRING_32 = "\uE01D"

	Numpad4_key: STRING_32 = "\uE01E"

	Numpad5_key: STRING_32 = "\uE01F"

	Numpad6_key: STRING_32 = "\uE020"

	Numpad7_key: STRING_32 = "\uE021"

	Numpad8_key: STRING_32 = "\uE022"

	Numpad9_key: STRING_32 = "\uE023"

	Multiply_key: STRING_32 = "\uE024"

	Add_key: STRING_32 = "\uE025"

	Separator_key: STRING_32 = "\uE026"

	Subtract_key: STRING_32 = "\uE027"

	Decimal_key: STRING_32 = "\uE028"

	Divide_key: STRING_32 = "\uE029"

	F1_key: STRING_32 = "\uE031"

	F2_key: STRING_32 = "\uE032"

	F3_key: STRING_32 = "\uE033"

	F4_key: STRING_32 = "\uE034"

	F5_key: STRING_32 = "\uE035"

	F6_key: STRING_32 = "\uE036"

	F7_key: STRING_32 = "\uE037"

	F8_key: STRING_32 = "\uE038"

	F9_key: STRING_32 = "\uE039"

	F10_key: STRING_32 = "\uE03A"

	F11_key: STRING_32 = "\uE03B"

	F12_key: STRING_32 = "\uE03C"

	Command_key: STRING_32 = "\uE03D"

	Meta_key: STRING_32 = "\uE03D"

	keys: ARRAY [STRING_32]
		once
			Result := <<Null_key, Cancel_key, Help_key, Backspace_key, Tab_key, Clear_key, Return_key, Enter_key, Shift_key, Control_key, Alt_key, Pause_key, Escape_key, Space_key, PageUp_key, PageDown_key, End_key, Home_key, LeftArrow_key, UpArrow_key, RightArrow_key, DownArrow_key, Insert_key, Delete_key, Semicolon_key, Equals_key, Numpad0_key, Numpad1_key, Numpad2_key, Numpad3_key, Numpad4_key, Numpad5_key, Numpad6_key, Numpad7_key, Numpad8_key, Numpad9_key, Multiply_key, Add_key, Separator_key, Subtract_key, Decimal_key, Divide_key, F1_key, F2_key, F3_key, F4_key, F5_key, F6_key, F7_key, F8_key, F9_key, F10_key, F11_key, F12_key, Command_key, Meta_key>>
		end

end
