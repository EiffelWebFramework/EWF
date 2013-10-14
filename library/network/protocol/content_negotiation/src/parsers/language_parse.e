note
	description: "[
		  {LANGUAGE_PARSE} is encharge to parse language tags defined as follow:

		  Accept-Language = "Accept-Language" ":"
                         1#( language-range [ ";" "q" "=" qvalue ] )
   	      language-range  = ( ( 1*8ALPHA *( "-" 1*8ALPHA ) ) | "*" )
   	      
   	      Example:
   	      Accept-Language: da, en-gb;q=0.8, en;q=0.7

	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Accept-Language", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4", "protocol=uri"

class
	LANGUAGE_PARSE

inherit {NONE}

	MIME_TYPE_PARSER_UTILITIES

	REFACTORING_HELPER

feature -- Parser

	parse_language (a_accept_language: READABLE_STRING_8): LANGUAGE_RESULTS
			-- Parses  `a_accept_language' request-header field into its component parts.
			-- For example, the language range 'en-gb;q=0.8' would get parsed
			-- into:
			-- ('en-gb', {'q':'0.8',})
		local
			l_parts: LIST [READABLE_STRING_8]
			p: READABLE_STRING_8
			sub_parts: LIST [READABLE_STRING_8]
			i: INTEGER
			l_full_type: READABLE_STRING_8
			l_types: LIST [READABLE_STRING_8]
		do
			fixme ("Improve code!!!")
			create Result.make
			l_parts := a_accept_language.split (';')
			from
				i := 1
			until
				i > l_parts.count
			loop
				p := l_parts.at (i)
				sub_parts := p.split ('=')
				if sub_parts.count = 2 then
					Result.put (trim (sub_parts [2]), trim (sub_parts [1]))
				end
				i := i + 1
			end

			l_full_type := trim (l_parts [1])
			if l_full_type.same_string ("*") then
				l_full_type := "*"
			end
			l_types := l_full_type.split ('-')
			if l_types.count = 1 then
				Result.set_type (trim (l_types [1]))
			else
				Result.set_type (trim (l_types [1]))
				Result.set_sub_type (trim (l_types [2]))
			end
		end

	parse_language_range (a_language_range: READABLE_STRING_8): LANGUAGE_RESULTS
			-- Languages-ranges are languages with wild-cards and a 'q' quality parameter.
			-- For example, the language range ('en-* ;q=0.5') would get parsed into:
			-- ('en', '*', {'q', '0.5'})
			-- In addition this function also guarantees that there is a value for 'q'
			-- in the params dictionary, filling it in with a proper default if
			-- necessary.
		do
			fixme ("Improve the code!!!")
			Result := parse_language (a_language_range)
			if attached Result.item ("q") as q then
				if q.is_double and then attached {REAL_64} q.to_double as r and then (r >= 0.0 and r <= 1.0) then
						--| Keep current value
					if q.same_string ("1") then
							--| Use 1.0 formatting
						Result.put ("1.0", "q")
					end
				else
					Result.put ("1.0", "q")
				end
			else
				Result.put ("1.0", "q")
			end
		end

	fitness_and_quality_parsed (a_language: READABLE_STRING_8; a_parsed_ranges: LIST [LANGUAGE_RESULTS]): FITNESS_AND_QUALITY
			-- Find the best match for a given `a_language' against a list of language ranges `a_parsed_ranges'
			-- that have already been parsed by parse_language_range.
		local
			best_fitness: INTEGER
			target_q: REAL_64
			best_fit_q: REAL_64
			target: LANGUAGE_RESULTS
			range: LANGUAGE_RESULTS
			keys: LIST [READABLE_STRING_8]
			param_matches: INTEGER
			element: detachable READABLE_STRING_8
			l_fitness: INTEGER
		do
			best_fitness := -1
			best_fit_q := 0.0
			target := parse_language_range (a_language)
			if attached target.item ("q") as q and then q.is_double then
				target_q := q.to_double
				if target_q < 0.0 then
					target_q := 0.0
				elseif target_q > 1.0 then
					target_q := 1.0
				end
			else
				target_q := 1.0
			end
			if attached target.type as l_target_type then
				from
					a_parsed_ranges.start
				until
					a_parsed_ranges.after
				loop
					range := a_parsed_ranges.item_for_iteration
					if (attached range.type as l_range_type and then (l_target_type.same_string (l_range_type) or l_range_type.same_string ("*") or l_target_type.same_string ("*"))) then
						from
							param_matches := 0
							keys := target.keys
							keys.start
						until
							keys.after
						loop
							element := keys.item_for_iteration
							if not element.same_string ("q") and then range.has_key (element) and then (attached target.item (element) as t_item and attached range.item (element) as r_item) and then t_item.same_string (r_item) then
								param_matches := param_matches + 1
							end
							keys.forth
						end
						if l_range_type.same_string (l_target_type) then
							l_fitness := 100
						else
							l_fitness := 0
						end
						if (attached range.sub_type as l_range_sub_type and then attached target.sub_type as l_target_sub_type and then (l_target_sub_type.same_string (l_range_sub_type) or l_range_sub_type.same_string ("*") or l_target_sub_type.same_string ("*"))) then
							if l_range_sub_type.same_string (l_target_sub_type) then
								l_fitness := l_fitness + 10
							end
						end
						l_fitness := l_fitness + param_matches
						if l_fitness > best_fitness then
							best_fitness := l_fitness
							element := range.item ("q")
							if element /= Void then
								best_fit_q := element.to_double.min (target_q)
							else
								best_fit_q := 0.0
							end
						end
					end
					a_parsed_ranges.forth
				end
			end
			create Result.make (best_fitness, best_fit_q)
		end

	quality_parsed (a_language: READABLE_STRING_8; a_parsed_ranges: LIST [LANGUAGE_RESULTS]): REAL_64
			--	Find the best match for a given `a_language' against a list of ranges `parsed_ranges' that
			--	have already been parsed by parse_language_range. Returns the 'q' quality
			--	parameter of the best match, 0 if no match was found. This function
			--	bahaves the same as quality except that 'a_parsed_ranges' must be a list
			--	of parsed language ranges.
		do
			Result := fitness_and_quality_parsed (a_language, a_parsed_ranges).quality
		end

	quality (a_language: READABLE_STRING_8; a_ranges: READABLE_STRING_8): REAL_64
			-- Returns the quality 'q' of a `a_language' when compared against the
			-- language range in `a_ranges'.
		local
			l_ranges: LIST [READABLE_STRING_8]
			res: ARRAYED_LIST [LANGUAGE_RESULTS]
			p_res: LANGUAGE_RESULTS
		do
			l_ranges := a_ranges.split (',')
			from
				create res.make (10);
				l_ranges.start
			until
				l_ranges.after
			loop
				p_res := parse_language_range (l_ranges.item_for_iteration)
				res.force (p_res)
				l_ranges.forth
			end
			Result := quality_parsed (a_language, res)
		end

	best_match (a_supported: LIST [READABLE_STRING_8]; a_header: READABLE_STRING_8): READABLE_STRING_8
			-- Choose the `language' with the highest fitness score and quality ('q') from a list of candidates.
		local
			l_header_results: LIST [LANGUAGE_RESULTS]
			weighted_matches: LIST [FITNESS_AND_QUALITY]
			l_res: LIST [READABLE_STRING_8]
			p_res: LANGUAGE_RESULTS
			fitness_and_quality, first_one: detachable FITNESS_AND_QUALITY
			s: READABLE_STRING_8
		do
			l_res := a_header.split (',')
			create {ARRAYED_LIST [LANGUAGE_RESULTS]} l_header_results.make (l_res.count)
			fixme ("Extract method!!!")
			from
				l_res.start
			until
				l_res.after
			loop
				p_res := parse_language_range (l_res.item_for_iteration)
				l_header_results.force (p_res)
				l_res.forth
			end
			create {ARRAYED_LIST [FITNESS_AND_QUALITY]} weighted_matches.make (a_supported.count)
			from
				a_supported.start
			until
				a_supported.after
			loop
				fitness_and_quality := fitness_and_quality_parsed (a_supported.item_for_iteration, l_header_results)
				fitness_and_quality.set_mime_type (mime_type (a_supported.item_for_iteration))
				weighted_matches.force (fitness_and_quality)
				a_supported.forth
			end

				--| Keep only top quality+fitness types
			from
				weighted_matches.start
				first_one := weighted_matches.item
				weighted_matches.forth
			until
				weighted_matches.after
			loop
				fitness_and_quality := weighted_matches.item
				if first_one < fitness_and_quality then
					first_one := fitness_and_quality
					if not weighted_matches.isfirst then
						from
							weighted_matches.back
						until
							weighted_matches.before
						loop
							weighted_matches.remove
							weighted_matches.back
						end
						weighted_matches.forth
					end
					check
						weighted_matches.item = fitness_and_quality
					end
					weighted_matches.forth
				elseif first_one.is_equal (fitness_and_quality) then
					weighted_matches.forth
				else
					check
						first_one > fitness_and_quality
					end
					weighted_matches.remove
				end
			end
			if first_one /= Void and then first_one.quality /= 0.0 then
				if weighted_matches.count = 1 then
					Result := first_one.mime_type
				else
					from
						fitness_and_quality := Void
						l_header_results.start
					until
						l_header_results.after or fitness_and_quality /= Void
					loop
						s := l_header_results.item.mime_type
						from
							weighted_matches.start
						until
							weighted_matches.after or fitness_and_quality /= Void
						loop
							fitness_and_quality := weighted_matches.item
							if fitness_and_quality.mime_type.same_string (s) then
									--| Found
							else
								fitness_and_quality := Void
								weighted_matches.forth
							end
						end
						l_header_results.forth
					end
					if fitness_and_quality /= Void then
						Result := fitness_and_quality.mime_type
					else
						Result := first_one.mime_type
					end
				end
			else
				Result := ""
			end
		end

note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
