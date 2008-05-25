indexing

	description: "Objects that execute test cases"
	author: "CDD Tool"

class
	CDD_ROOT_CLASS

create
	make

feature {NONE} -- Initialization

	make is
		local
			l_abstract_test_case: CDD_TEST_CASE
			l_test_case: TEST_JSON_OBJECTS
		do
			create l_test_case
			l_abstract_test_case := l_test_case
			l_abstract_test_case.set_up
			l_test_case.test_has_key
			l_abstract_test_case.tear_down
		end


end
