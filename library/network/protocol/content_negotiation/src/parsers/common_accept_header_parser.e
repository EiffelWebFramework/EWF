note
	description: "[
					COMMON_ACCEPT_HEADER_PARSER, this class allows to parse Accept-Charset and Accept-Encoding headers

		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Charset", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.2", "protocol=uri"
	EIS: "name=Encoding", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.3", "protocol=uri"

class
	COMMON_ACCEPT_HEADER_PARSER

inherit {NONE}

	MIME_TYPE_PARSER_UTILITIES


feature -- Parser

	parse_common (header: READABLE_STRING_8): COMMON_RESULTS
			-- Parses `header' charset/encoding into its component parts.
			-- For example, the charset 'iso-8889-5' would get parsed
			-- into:
			-- ('iso-8889-5', {'q':'1.0'})
		local
			l_parts: LIST [READABLE_STRING_8]
			sub_parts: LIST [READABLE_STRING_8]
			p: READABLE_STRING_8
			i: INTEGER
			l_header: READABLE_STRING_8
		do
			create Result.make
			l_parts := header.split (';')
			if l_parts.count = 1 then
				Result.put ("1.0", "q")
			else
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
			end
			l_header := trim (l_parts [1])
			Result.set_field (trim (l_header))
		end

	fitness_and_quality_parsed (a_field: READABLE_STRING_8; a_parsed_charsets: LIST [COMMON_RESULTS]): FITNESS_AND_QUALITY
			-- Find the best match for a given charset/encoding against a list of charsets/encodings
			-- that have already been parsed by parse_common. Returns a
			-- tuple of the fitness value and the value of the 'q' quality parameter of
			-- the best match, or (-1, 0) if no match was found. Just as for
			-- quality_parsed().
		local
			best_fitness: INTEGER
			target_q: REAL_64
			best_fit_q: REAL_64
			target: COMMON_RESULTS
			range: COMMON_RESULTS
			element: detachable READABLE_STRING_8
			l_fitness: INTEGER
		do
			best_fitness := -1
			best_fit_q := 0.0
			target := parse_common (a_field)
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
			if attached target.field as l_target_field then
				from
					a_parsed_charsets.start
				until
					a_parsed_charsets.after
				loop
					range := a_parsed_charsets.item_for_iteration
					if attached range.field as l_range_common then
						if l_target_field.same_string (l_range_common) or l_target_field.same_string ("*") or l_range_common.same_string ("*") then
							if l_range_common.same_string (l_target_field) then
								l_fitness := 100
							else
								l_fitness := 0
							end
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
					end
					a_parsed_charsets.forth
				end
			end
			create Result.make (best_fitness, best_fit_q)
		end

	quality_parsed (a_field: READABLE_STRING_8; parsed_common: LIST [COMMON_RESULTS]): REAL_64
			--	Find the best match for a given charset/encoding against a list of charsets/encodings that
			--	have already been parsed by parse_charsets(). Returns the 'q' quality
			--	parameter of the best match, 0 if no match was found. This function
			--	bahaves the same as quality()
		do
			Result := fitness_and_quality_parsed (a_field, parsed_common).quality
		end

	quality (a_field: READABLE_STRING_8; commons: READABLE_STRING_8): REAL_64
			-- Returns the quality 'q' of a charset/encoding when compared against the
			-- a list of charsets/encodings/
		local
			l_commons: LIST [READABLE_STRING_8]
			res: ARRAYED_LIST [COMMON_RESULTS]
			p_res: COMMON_RESULTS
		do
			l_commons := commons.split (',')
			from
				create res.make (10)
				l_commons.start
			until
				l_commons.after
			loop
				p_res := parse_common (l_commons.item_for_iteration)
				res.force (p_res)
				l_commons.forth
			end
			Result := quality_parsed (a_field, res)
		end

	best_match (supported: LIST [READABLE_STRING_8]; header: READABLE_STRING_8): READABLE_STRING_8
			-- Choose the accept with the highest fitness score and quality ('q') from a list of candidates.
		local
			l_header_results: LIST [COMMON_RESULTS]
			weighted_matches: LIST [FITNESS_AND_QUALITY]
			l_res: LIST [READABLE_STRING_8]
			p_res: COMMON_RESULTS
			fitness_and_quality, first_one: detachable FITNESS_AND_QUALITY
		do
			l_res := header.split (',')
			create {ARRAYED_LIST [COMMON_RESULTS]} l_header_results.make (l_res.count)
			from
				l_res.start
			until
				l_res.after
			loop
				p_res := parse_common (l_res.item_for_iteration)
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
				--| TODO extract method
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
						if attached l_header_results.item.field as l_field then
							from
								weighted_matches.start
							until
								weighted_matches.after or fitness_and_quality /= Void
							loop
								fitness_and_quality := weighted_matches.item
								if fitness_and_quality.mime_type.same_string (l_field) then
										--| Found
								else
									fitness_and_quality := Void
									weighted_matches.forth
								end
							end
						else
							check
								has_field: False
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
