note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_SE_BY

inherit
	EQA_TEST_SET
		redefine
			on_prepare,
			on_clean
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
--			assert ("not_implemented", False)
		end

	on_clean
			-- <Precursor>
		do
--			assert ("not_implemented", False)
		end

feature -- Test routines

	test_valid_strategy_id
		local
			l_data : STRING_32
		do
			l_data := "[
			{"using":"id", "value":"test"}
			]"
			assert ("Expected true", (create {SE_BY}).is_valid_strategy (l_data))
		end

	test_valid_strategy_name
		local
			l_data : STRING_32
		do
			l_data := "[
			{"using":"name", "value":"test"}
			]"
			assert ("Expected true", (create {SE_BY}).is_valid_strategy (l_data))
		end

	test_wrong_strategy
		local
			l_data : STRING_32
		do
			l_data := "[
			{"using":"wrong", "value":"test"}
			]"
			assert ("Expected False", not (create {SE_BY}).is_valid_strategy (l_data))
		end


end


