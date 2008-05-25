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
				if a_name.count >= 10 and then a_name.substring (1, 10).is_equal ("TEST_JSON_") then
					i := i + 10
					if a_name.count >= i then
						c := a_name.item (i)
						i := i + 1
						inspect c
						when 'S' then
							if a_name.substring (12, a_name.count).is_equal ("TRING") then
								Result := create {TEST_JSON_STRING}
							end
						when 'O' then
							if a_name.substring (12, a_name.count).is_equal ("BJECTS") then
								Result := create {TEST_JSON_OBJECTS}
							end
						else
							-- Do nothing.
						end
					end
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
				if a_name.count >= 10 and then a_name.substring (1, 10).is_equal ("TEST_JSON_") then
					i := i + 10
					if a_name.count >= i then
						c := a_name.item (i)
						i := i + 1
						inspect c
						when 'S' then
							if a_name.substring (12, a_name.count).is_equal ("TRING.test_1") then
								Result := agent {TEST_JSON_STRING}.test_1
							end
						when 'O' then
							if a_name.count >= 23 and then a_name.substring (12, 23).is_equal ("BJECTS.test_") then
								i := i + 12
								if a_name.count >= i then
									c := a_name.item (i)
									i := i + 1
									inspect c
									when 'j' then
										if a_name.count >= 28 and then a_name.substring (25, 28).is_equal ("son_") then
											i := i + 4
											if a_name.count >= i then
												c := a_name.item (i)
												i := i + 1
												inspect c
												when 'v' then
													if a_name.substring (30, a_name.count).is_equal ("alue") then
														Result := agent {TEST_JSON_OBJECTS}.test_json_value
													end
												when 'o' then
													if a_name.substring (30, a_name.count).is_equal ("bjects_items") then
														Result := agent {TEST_JSON_OBJECTS}.test_json_objects_items
													end
												else
													-- Do nothing.
												end
											end
										end
									when 'c' then
										if a_name.count >= i then
											c := a_name.item (i)
											i := i + 1
											inspect c
											when 'u' then
												if a_name.substring (26, a_name.count).is_equal ("rrent_keys") then
													Result := agent {TEST_JSON_OBJECTS}.test_current_keys
												end
											when 'o' then
												if a_name.substring (26, a_name.count).is_equal ("nversion_to_json_object") then
													Result := agent {TEST_JSON_OBJECTS}.test_conversion_to_json_object
												end
											else
												-- Do nothing.
											end
										end
									when 'h' then
										if a_name.count >= 27 and then a_name.substring (25, 27).is_equal ("as_") then
											i := i + 3
											if a_name.count >= i then
												c := a_name.item (i)
												i := i + 1
												inspect c
												when 'k' then
													if a_name.substring (29, a_name.count).is_equal ("ey") then
														Result := agent {TEST_JSON_OBJECTS}.test_has_key
													end
												when 'n' then
													if a_name.substring (29, a_name.count).is_equal ("ot_key") then
														Result := agent {TEST_JSON_OBJECTS}.test_has_not_key
													end
												when 'i' then
													if a_name.substring (29, a_name.count).is_equal ("tem") then
														Result := agent {TEST_JSON_OBJECTS}.test_has_item
													end
												else
													-- Do nothing.
												end
											end
										end
									else
										-- Do nothing.
									end
								end
							end
						else
							-- Do nothing.
						end
					end
				end
			end
		end


end
