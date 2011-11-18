note
	description: "Summary description for {LANGUAGE_PARSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	description : "Language Reference: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4"

class
	LANGUAGE_PARSE
inherit
	REFACTORING_HELPER

feature -- Parser

	parse_mime_type (a_mime_type: STRING): LANGUAGE_RESULTS
			-- Parses a mime-type into its component parts.
			-- For example, the media range 'application/xhtml;q=0.5' would get parsed
			-- into:
			-- ('application', 'xhtml', {'q', '0.5'})
		local
			l_parts: LIST [STRING]
			p: STRING
			sub_parts: LIST [STRING]
			i: INTEGER
			l_full_type: STRING
			l_types: LIST [STRING]
		do
			fixme ("Improve code!!!")
			create Result.make
			l_parts := a_mime_type.split (';')
			from
				i := 1
			until
				i > l_parts.count
			loop
				p := l_parts.at (i)
				sub_parts := p.split ('=')
				if sub_parts.count = 2 then
					Result.put (trim (sub_parts[2]), trim (sub_parts[1]))
				end
				i := i + 1
			end
			--Java URLConnection class sends an Accept header that includes a
			--single "*" - Turn it into a legal wildcard.

			l_full_type := trim (l_parts[1])
			if l_full_type.same_string ("*") then
				l_full_type := "*"
			end
			l_types := l_full_type.split ('-')
			if l_types.count = 1 then
				Result.set_type (trim (l_types[1]))
			else
				Result.set_type (trim (l_types[1]))
				Result.set_sub_type (trim (l_types[2]))
			end
		end

	parse_media_range (a_range: STRING): LANGUAGE_RESULTS
			-- Media-ranges are mime-types with wild-cards and a 'q' quality parameter.
			-- For example, the media range 'application/*;q=0.5' would get parsed into:
			-- ('application', '*', {'q', '0.5'})
			-- In addition this function also guarantees that there is a value for 'q'
			-- in the params dictionary, filling it in with a proper default if
			-- necessary.
		do
			fixme ("Improve the code!!!")
			Result := parse_mime_type (a_range)
			if attached Result.item ("q") as q then
				if
					q.is_double and then
					attached {REAL_64} q.to_double as r and then
					(r >= 0.0 and r <= 1.0)
				then
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


	fitness_and_quality_parsed (a_mime_type: STRING; parsed_ranges: LIST [LANGUAGE_RESULTS]): FITNESS_AND_QUALITY
			-- Find the best match for a given mimeType against a list of media_ranges
			-- that have already been parsed by parse_media_range. Returns a
			-- tuple of the fitness value and the value of the 'q' quality parameter of
			-- the best match, or (-1, 0) if no match was found. Just as for
			-- quality_parsed(), 'parsed_ranges' must be a list of parsed media ranges.
		local
			best_fitness: INTEGER
			target_q: REAL_64
			best_fit_q: REAL_64
			target: LANGUAGE_RESULTS
			range: LANGUAGE_RESULTS
			keys: LIST [STRING]
			param_matches: INTEGER
			element: detachable STRING
			l_fitness: INTEGER
		do
			best_fitness := -1
			best_fit_q := 0.0
			target := parse_media_range (a_mime_type)
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

			if
				attached target.type as l_target_type
			then
				from
					parsed_ranges.start
				until
					parsed_ranges.after
				loop
					range := parsed_ranges.item_for_iteration
					if
						(
							attached range.type as l_range_type and then
							(l_target_type.same_string (l_range_type) or l_range_type.same_string ("*") or l_target_type.same_string ("*"))
						)
					then
						from
							param_matches := 0
							keys := target.keys
							keys.start
						until
							keys.after
						loop
							element := keys.item_for_iteration
							if
								not element.same_string ("q") and then
								range.has_key (element) and then
								(attached target.item (element) as t_item and attached range.item (element) as r_item) and then
								t_item.same_string (r_item)
							then
								param_matches := param_matches + 1
							end
							keys.forth
						end

						if l_range_type.same_string (l_target_type) then
							l_fitness := 100
						else
							l_fitness := 0
						end
						if 	(
							attached range.sub_type as l_range_sub_type and then attached target.sub_type as l_target_sub_type and then
							(l_target_sub_type.same_string (l_range_sub_type) or l_range_sub_type.same_string ("*") or l_target_sub_type.same_string ("*"))
						) then
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
					parsed_ranges.forth
				end
			end
			create Result.make (best_fitness, best_fit_q)
		end

	quality_parsed (a_mime_type: STRING; parsed_ranges: LIST [LANGUAGE_RESULTS]): REAL_64
			--	Find the best match for a given mime-type against a list of ranges that
			--	have already been parsed by parseMediaRange(). Returns the 'q' quality
			--	parameter of the best match, 0 if no match was found. This function
			--	bahaves the same as quality() except that 'parsed_ranges' must be a list
			--	of parsed media ranges.
		do
			Result := fitness_and_quality_parsed (a_mime_type, parsed_ranges).quality
		end

	quality (a_mime_type: STRING; ranges: STRING): REAL_64
			-- Returns the quality 'q' of a mime-type when compared against the
			-- mediaRanges in ranges.
		local
			l_ranges : LIST [STRING]
			res : ARRAYED_LIST [LANGUAGE_RESULTS]
			p_res : LANGUAGE_RESULTS
		do
			l_ranges := ranges.split (',')
			from
				create res.make (10);
				l_ranges.start
			until
				l_ranges.after
			loop
				p_res := parse_media_range (l_ranges.item_for_iteration)
				res.put_left (p_res)
				l_ranges.forth
			end
			Result := quality_parsed (a_mime_type, res)
		end

	best_match (supported: LIST [STRING]; header: STRING): STRING
			-- Choose the mime-type with the highest fitness score and quality ('q') from a list of candidates.
		local
			l_header_results: LIST [LANGUAGE_RESULTS]
			weighted_matches: LIST [FITNESS_AND_QUALITY]
			l_res: LIST [STRING]
			p_res: LANGUAGE_RESULTS
			fitness_and_quality, first_one: detachable FITNESS_AND_QUALITY
			s: STRING
		do
			l_res := header.split (',')
			create {ARRAYED_LIST [LANGUAGE_RESULTS]} l_header_results.make (l_res.count)

			fixme("Extract method!!!")
			from
				l_res.start
			until
				l_res.after
			loop
				p_res := parse_media_range (l_res.item_for_iteration)
				l_header_results.force (p_res)
				l_res.forth
			end

			create {ARRAYED_LIST [FITNESS_AND_QUALITY]} weighted_matches.make (supported.count)

			from
				supported.start
			until
				supported.after
			loop
				fitness_and_quality := fitness_and_quality_parsed (supported.item_for_iteration, l_header_results)
				fitness_and_quality.set_mime_type (mime_type (supported.item_for_iteration))
				weighted_matches.force (fitness_and_quality)
				supported.forth
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
					check weighted_matches.item = fitness_and_quality end
					weighted_matches.forth
				elseif first_one.is_equal (fitness_and_quality) then
					weighted_matches.forth
				else
					check first_one > fitness_and_quality end
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

feature {NONE} -- Implementation

	mime_type (s: STRING): STRING
		local
			p: INTEGER
		do
			p := s.index_of (';', 1)
			if p > 0 then
				Result := trim (s.substring (1, p - 1))
			else
				Result := trim (s.string)
			end
		end

	trim (a_string: STRING): STRING
			-- trim whitespace from the beginning and end of a string
		require
			valid_argument : a_string /= Void
		do
			a_string.left_adjust
			a_string.right_justify
			Result := a_string
		ensure
			result_same_as_argument: a_string = Result
		end

note
	copyright: "2011-2011, Javier Velilla, Jocelyn Fiat and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
