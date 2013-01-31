note
	description: "[
				Summary description for {HTTP_DATE}.
				
				
			       HTTP-date    = rfc1123-date | rfc850-date | asctime-date
			       rfc1123-date = wkday "," SP date1 SP time SP "GMT"
			       rfc850-date  = weekday "," SP date2 SP time SP "GMT"
			       asctime-date = wkday SP date3 SP time SP 4DIGIT
			       date1        = 2DIGIT SP month SP 4DIGIT
			                      ; day month year (e.g., 02 Jun 1982)
			       date2        = 2DIGIT "-" month "-" 2DIGIT
			                      ; day-month-year (e.g., 02-Jun-82)
			       date3        = month SP ( 2DIGIT | ( SP 1DIGIT ))
			                      ; month day (e.g., Jun  2)
			       time         = 2DIGIT ":" 2DIGIT ":" 2DIGIT
			                      ; 00:00:00 - 23:59:59
			       wkday        = "Mon" | "Tue" | "Wed"
			                    | "Thu" | "Fri" | "Sat" | "Sun"
			       weekday      = "Monday" | "Tuesday" | "Wednesday"
			                    | "Thursday" | "Friday" | "Saturday" | "Sunday"
			       month        = "Jan" | "Feb" | "Mar" | "Apr"
			                    | "May" | "Jun" | "Jul" | "Aug"
			                    | "Sep" | "Oct" | "Nov" | "Dec"
			                    
			 Sun, 06 Nov 1994 08:49:37 GMT  ; RFC 822, updated by RFC 1123
			 Sunday, 06-Nov-94 08:49:37 GMT ; RFC 850, obsoleted by RFC 1036
			 
			 Not supported:
			 Sun Nov  6 08:49:37 1994       ; ANSI C's asctime() format

			]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=RFC2616", "protocol=URI", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html"

class
	HTTP_DATE

inherit
	DEBUG_OUTPUT

create
	make_from_timestamp,
	make_from_string,
	make_from_date_time

feature {NONE} -- Initialization

	make_from_timestamp (n: INTEGER_64)
			-- Build from unix timestamp `n'
		do
			internal_timestamp := n
				--| FIXME: find workaround when `n' is not INTEGER_32
			create date_time.make_from_epoch (n.as_integer_32)
		end

	make_from_string (s: READABLE_STRING_8)
			-- Create from string representation `s'
			-- Supports: RFC 1123 and RFC 850
			-- Tolerant with: GMT+offset and GMT-offset
			--| Sun, 06 Nov 1994 08:49:37 GMT  ; RFC 822, updated by RFC 1123
			--| Sunday, 06-Nov-94 08:49:37 GMT ; RFC 850, obsoleted by RFC 1036
			--| Does not support ANSI C's asctime() format
		do
			if attached string_to_date_time (s) as dt then
				date_time := dt
			else
				has_error := True
				date_time := epoch
			end
		end

	make_from_date_time (dt: DATE_TIME)
			-- Build from date `dt'
		do
			date_time := dt
		end

feature -- Access

	has_error: BOOLEAN
			-- Error occurred during creation with `make_from_string'?

	date_time: DATE_TIME
			-- Associated Date time.

	string: STRING
			-- String representation recommended for HTTP date.
			--| Sun, 06 Nov 1994 08:49:37 GMT			
		do
			Result := rfc1123_string
		end

	rfc1123_string: STRING
			-- String representation following RFC 1123.
			--| Sun, 06 Nov 1994 08:49:37 GMT  ; RFC 822, updated by RFC 1123
		local
			s: like internal_rfc1123_string
		do
			s := internal_rfc1123_string
			if s = Void then
				s := date_time_to_rfc1123_string (date_time)
				internal_rfc1123_string := s
			end
			Result := s
		end

	rfc850_string: STRING
			-- String representation following RFC 850
		do
			Result := date_time_to_rfc850_string (date_time)
		end

	timestamp: INTEGER_64
			-- Unix timestamp.
		do
			Result := internal_timestamp
			if Result = 0 then
				Result := date_time.definite_duration (epoch).seconds_count
				internal_timestamp := Result
			end
		end

feature -- Status report

	debug_output: STRING
		do
			if attached internal_rfc1123_string as st then
				Result := st.string
			else
				Result := date_time_to_rfc1123_string (date_time)
			end
		end

feature {NONE} -- Implementation

	epoch: DATE_TIME
		once ("THREAD")
			create Result.make_from_epoch (0)
		end

	internal_timestamp: like timestamp

	internal_rfc1123_string: detachable STRING

	date_time_to_rfc1123_string (dt: DATE_TIME): STRING
		local
			i: INTEGER
		do
			create Result.make (32)
			i := dt.date.day_of_the_week
			inspect i
			when 1 then Result.append ("Sun")
			when 2 then Result.append ("Mon")
			when 3 then Result.append ("Tue")
			when 4 then Result.append ("Wed")
			when 5 then Result.append ("Thu")
			when 6 then Result.append ("Fri")
			when 7 then Result.append ("Sat")
			else
				-- Error				
			end
			Result.append_character (',')

				-- SPace
			Result.append_character (' ')

				-- dd
			i := dt.day
			if i <= 9 then
				Result.append_character ('0')
			end
			Result.append_integer (i)

				-- SPace
			Result.append_character (' ')

				-- mmm
			i := dt.month
			inspect i
			when 1 then Result.append ("Jan")
			when 2 then Result.append ("Feb")
			when 3 then Result.append ("Mar")
			when 4 then Result.append ("Apr")
			when 5 then Result.append ("May")
			when 6 then Result.append ("Jun")
			when 7 then Result.append ("Jul")
			when 8 then Result.append ("Aou")
			when 9 then Result.append ("Sep")
			when 10 then Result.append ("Oct")
			when 11 then Result.append ("Nov")
			when 12 then Result.append ("Dec")
			else
				-- Error				
			end

				-- SPace
			Result.append_character (' ')

				-- yyyy
			Result.append_integer (dt.year)

				-- SPace
			Result.append_character (' ')

				-- hh
			i := dt.hour
			if i <= 9 then
				Result.append_character ('0')
			end
			Result.append_integer (i)

				-- ':'
			Result.append_character (':')

				-- mi
			i := dt.minute
			if i <= 9 then
				Result.append_character ('0')
			end
			Result.append_integer (i)

				-- ':'
			Result.append_character (':')

				-- ss
			i := dt.second
			if i <= 9 then
				Result.append_character ('0')
			end
			Result.append_integer (i)

				-- SPace + GMT
			Result.append (" GMT")
		end

	date_time_to_rfc850_string (dt: DATE_TIME): STRING
		local
			i: INTEGER
		do
			create Result.make (32)
			i := dt.date.day_of_the_week
			inspect i
			when 1 then Result.append ("Sunday")
			when 2 then Result.append ("Monday")
			when 3 then Result.append ("Tuesday")
			when 4 then Result.append ("Wednesday")
			when 5 then Result.append ("Thursday")
			when 6 then Result.append ("Friday")
			when 7 then Result.append ("Satursday")
			else
				-- Error				
			end
			Result.append_character (',')

				-- SPace
			Result.append_character (' ')

				-- dd
			i := dt.day
			if i <= 9 then
				Result.append_character ('0')
			end
			Result.append_integer (i)

				-- '-'
			Result.append_character ('-')

				-- mmm
			i := dt.month
			inspect i
			when 1 then Result.append ("Jan")
			when 2 then Result.append ("Feb")
			when 3 then Result.append ("Mar")
			when 4 then Result.append ("Apr")
			when 5 then Result.append ("May")
			when 6 then Result.append ("Jun")
			when 7 then Result.append ("Jul")
			when 8 then Result.append ("Aou")
			when 9 then Result.append ("Sep")
			when 10 then Result.append ("Oct")
			when 11 then Result.append ("Nov")
			when 12 then Result.append ("Dec")
			else
				-- Error				
			end

				-- '-'
			Result.append_character ('-')

				-- yy
			Result.append_integer (dt.year \\ 100)

				-- SPace
			Result.append_character (' ')

				-- hh
			i := dt.hour
			if i <= 9 then
				Result.append_character ('0')
			end
			Result.append_integer (i)

				-- ':'
			Result.append_character (':')

				-- mi
			i := dt.minute
			if i <= 9 then
				Result.append_character ('0')
			end
			Result.append_integer (i)

				-- ':'
			Result.append_character (':')

				-- ss
			i := dt.second
			if i <= 9 then
				Result.append_character ('0')
			end
			Result.append_integer (i)

				-- SPace + GMT
			Result.append (" GMT")
		end

	string_to_date_time (s: READABLE_STRING_8): detachable DATE_TIME
			-- String representation of `dt' using the RFC 1123
			--       HTTP-date    = rfc1123-date | rfc850-date | asctime-date
			--       rfc1123-date = wkday "," SP date1 SP time SP "GMT"
			--       rfc850-date  = weekday "," SP date2 SP time SP "GMT"
			--       asctime-date = wkday SP date3 SP time SP 4DIGIT
			--       date1        = 2DIGIT SP month SP 4DIGIT
			--                      ; day month year (e.g., 02 Jun 1982)
			--       date2        = 2DIGIT "-" month "-" 2DIGIT
			--                      ; day-month-year (e.g., 02-Jun-82)
			--       date3        = month SP ( 2DIGIT | ( SP 1DIGIT ))
			--                      ; month day (e.g., Jun  2)
			--       time         = 2DIGIT ":" 2DIGIT ":" 2DIGIT
			--                      ; 00:00:00 - 23:59:59
			--       wkday        = "Mon" | "Tue" | "Wed"
			--                    | "Thu" | "Fri" | "Sat" | "Sun"
			--       weekday      = "Monday" | "Tuesday" | "Wednesday"
			--                    | "Thursday" | "Friday" | "Saturday" | "Sunday"
			--       month        = "Jan" | "Feb" | "Mar" | "Apr"
			--                    | "May" | "Jun" | "Jul" | "Aug"
			--                    | "Sep" | "Oct" | "Nov" | "Dec"
			--| Sun, 06 Nov 1994 08:49:37 GMT  ; RFC 822, updated by RFC 1123
			--| Sunday, 06-Nov-94 08:49:37 GMT ; RFC 850, obsoleted by RFC 1036
			--|
			--| ANSI C's format not support for now
			--| Sun Nov  6 08:49:37 1994       ; ANSI C's asctime() format
		note
			EIS: "name=RFC2616", "protocol=URI", "src=http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html"
		local
			t: STRING_8
			l_ddd, l_mmm: detachable STRING_8
			l_dd, l_yyyy, l_hh, l_mi, l_ss, l_ff2: INTEGER
			l_mo: INTEGER
			l_gmt_offset: INTEGER
			i, n: INTEGER
			err: BOOLEAN
		do
			i := 1
			n := s.count
			create t.make (4)

				-- Skip blanks
			from until i > n or else not s[i].is_space  loop i := i + 1 end

				--| ddd
			t.wipe_out
			from until i > n or else not s[i].is_alpha loop
				t.extend (s[i])
				i := i + 1
			end
			if i <= n and t.count >= 3 then -- Accept full day string
				l_ddd := t.as_lower
			else
				err := True
			end

				--| blanks
			from until i > n or else not s[i].is_space  loop i := i + 1 end

				--| ,[0]dd
			if not err and i <= n and s[i] = ',' then
				i := i + 1
				from until i > n or else not s[i].is_space  loop i := i + 1 end
				t.wipe_out
				from until i > n or else not s[i].is_digit loop
					t.extend (s[i])
					i := i + 1
				end
				if i <= n and t.count > 0 then
					check t.is_integer end
					l_dd := t.to_integer
				else
					err := True
				end
			else
				err := True
			end

				--| blanks or '-'
			if s[i] = '-' then
				i := i + 1
			else
				from until i > n or else not s[i].is_space  loop i := i + 1 end
			end

				--| mmm
			if not err then
				t.wipe_out
				from until i > n or else not s[i].is_alpha loop
					t.extend (s[i])
					i := i + 1
				end
				if i <= n and t.count = 3 then
					l_mmm := t.as_upper
					if     l_mmm.same_string ("JAN") then l_mo := 01
					elseif l_mmm.same_string ("FEB") then l_mo := 02
					elseif l_mmm.same_string ("MAR") then l_mo := 03
					elseif l_mmm.same_string ("APR") then l_mo := 04
					elseif l_mmm.same_string ("MAY") then l_mo := 05
					elseif l_mmm.same_string ("JUN") then l_mo := 06
					elseif l_mmm.same_string ("JUL") then l_mo := 07
					elseif l_mmm.same_string ("AOU") then l_mo := 08
					elseif l_mmm.same_string ("SEP") then l_mo := 09
					elseif l_mmm.same_string ("OCT") then l_mo := 10
					elseif l_mmm.same_string ("NOV") then l_mo := 11
					elseif l_mmm.same_string ("DEC") then l_mo := 12
					else err := True
					end
				else
					err := True
				end
			end

				--| blanks or '-'
			if s[i] = '-' then
				i := i + 1
			else
				from until i > n or else not s[i].is_space  loop i := i + 1 end
			end

				--| yyyy
			if not err then

				t.wipe_out
				from until i > n or else not s[i].is_digit loop
					t.extend (s[i])
					i := i + 1
				end
				if i <= n and t.count > 0 then
					check t.count = 4 or t.count = 2 and t.is_integer end
					l_yyyy := t.to_integer
					if t.count = 2 then
						-- RFC 850
						l_yyyy := 1900 + l_yyyy
					end
				else
					err := True
				end
			end

				--| blank						
			from until i > n or else not s[i].is_space  loop i := i + 1 end

				--| [0]hh:
			if not err then
				t.wipe_out
				from until i > n or else not s[i].is_digit loop
					t.extend (s[i])
					i := i + 1
				end
				if i <= n and t.count > 0 and s[i] = ':' then
					check t.count = 2 and t.is_integer end
					l_hh := t.to_integer
					i := i + 1
				else
					err := True
				end
			end

				--| [0]mi:
			if not err then
				t.wipe_out
				from until i > n or else not s[i].is_digit loop
					t.extend (s[i])
					i := i + 1
				end
				if i <= n and t.count > 0 and s[i] = ':' then
					check t.count = 2 and t.is_integer end
					l_mi := t.to_integer
					i := i + 1
				else
					err := True
				end
			end
				--| [0]ss
			if not err then
				t.wipe_out
				from until i > n or else not s[i].is_digit loop
					t.extend (s[i])
					i := i + 1
				end
				if i <= n and t.count > 0 then
					check t.count = 2 and t.is_integer end
					l_ss := t.to_integer
				else
					err := True
				end
			end

				--| .ff2
			if not err and s[i] = '.' then
					--| .ff2
				i := i + 1
				t.wipe_out
				from until i > n or else not s[i].is_digit loop
					t.extend (s[i])
					i := i + 1
				end
				if i <= n and t.count > 0 then
					check t.is_integer end
					l_ff2 := t.to_integer
				else
					err := True
				end
			end

			if not err then
				from until i > n or else not s[i].is_space  loop i := i + 1 end
				t.wipe_out
				from until i > n or else not s[i].is_alpha loop
					t.extend (s[i].as_upper)
					i := i + 1
				end
				if t.same_string ("GMT") then
					from until i > n or else not s[i].is_space  loop i := i + 1 end
					if i <= n then
						t.wipe_out
						if s[i] = '+' then
							t.extend (s[i])
						elseif s[i] = '-' then
							t.extend (s[i])
						else
							err := True
						end
						if not err then
							i := i + 1
							from until i > n or else not s[i].is_digit loop
								t.extend (s[i].as_upper)
								i := i + 1
							end
							l_gmt_offset := t.to_integer
						end
					end
				else
					err := True
				end
			end

			if not err then
				check
					valid_yyyy: 0 < l_yyyy
					valid_dd: 0 < l_dd and l_dd <= 31
					valid_mo: 0 < l_mo and l_mo <= 12
					valid_hh: 0 <= l_hh and l_hh <= 23
					valid_mi: 0 <= l_mi and l_mi <= 59
					valid_ss: 0 <= l_ss and l_ss <= 59
				end
				create Result.make (l_yyyy, l_mo, l_dd, l_hh, l_mi, l_ss)
				if l_gmt_offset /= 0 then
					Result.hour_add (- l_gmt_offset)
				end
			else
--				create Result.make_utc_now
			end
		end

invariant

note
	copyright: "2011-2013, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
