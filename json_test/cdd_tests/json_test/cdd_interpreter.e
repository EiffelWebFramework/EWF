indexing

	description: "Objects that execute test cases"
	author: "CDD Tool"

class
	CDD_INTERPRETER

inherit
	CDD_ABSTRACT_INTERPRETER

create
	execute
feature
	test_class_instance (a_name: STRING): CDD_TEST_CASE is
		local
			i: INTEGER
			c: CHARACTER
		do
			i := 1
			if a_name /= Void then 
				if a_name.substring (1, a_name.count).is_equal ("TEST_JSON_OBJECTS") then
					Result := create {TEST_JSON_OBJECTS}
				end
			end
		end

	test_procedure (a_name: STRING): PROCEDURE [ANY, TUPLE [CDD_TEST_CASE]] is
		local
			i: INTEGER
			c: CHARACTER
		do
			i := 1
			if a_name /= Void then 
				if a_name.count >= 23 and then a_name.substring (1, 23).is_equal ("TEST_JSON_OBJECTS.test_") then
					i := i + 23
					if a_name.count >= i then
						c := a_name.item (i)
						i := i + 1
						inspect c
						when 'h' then
							if a_name.count >= 27 and then a_name.substring (25, 27).is_equal ("as_") then
								i := i + 3
								if a_name.count >= i then
									c := a_name.item (i)
									i := i + 1
									inspect c
									when 'n' then
										if a_name.substring (29, a_name.count).is_equal ("ot_key") then
											Result := agent {TEST_JSON_OBJECTS}.test_has_not_key
										end
									when 'k' then
										if a_name.substring (29, a_name.count).is_equal ("ey") then
											Result := agent {TEST_JSON_OBJECTS}.test_has_key
										end
									else
										-- Do nothing.
									end
								end
							end
						when 'c' then
							if a_name.substring (25, a_name.count).is_equal ("urrent_keys") then
								Result := agent {TEST_JSON_OBJECTS}.test_current_keys
							end
						else
							-- Do nothing.
						end
					end
				end
			end
		end


end
