note
	description: "Object that represents a result after parsing Language Headers."
	date: "$Date$"
	revision: "$Revision$"

class
	HTTP_ACCEPT_LANGUAGE

inherit
	REFACTORING_HELPER

	DEBUG_OUTPUT

create
	make_from_string,
	make,
	make_with_language,
	make_default

feature {NONE} -- Initialization

	make_from_string (a_accept_language_item: READABLE_STRING_8)
			-- Instantiate Current from part of accept-language header, i.e language tag and parameters.
			--
			-- Languages-ranges are languages with specialization and a 'q' quality parameter.
			-- For example, the language l_range ('en-* ;q=0.5') would get parsed into:
			-- ('en', '*', {'q', '0.5'})
			-- In addition this also guarantees that there is a value for 'q'
			-- in the params dictionary, filling it in with a proper default if
			-- necessary.
		require
			a_accept_language_item_not_empty: not a_accept_language_item.is_empty
		local
			l_parts: LIST [READABLE_STRING_8]
			p: READABLE_STRING_8
			i: INTEGER
			l_tag: STRING_8
		do
			fixme (generator + ".make_from_string: improve code!!!")
			l_parts := a_accept_language_item.split (';')
			from
				l_parts.start
				make_with_language (trimmed_string (l_parts.item))
				if not l_parts.after then
					l_parts.forth
				end
			until
				l_parts.after
			loop
				p := l_parts.item
				i := p.index_of ('=', 1)
				if i > 0 then
					put (trimmed_string (p.substring (i + 1, p.count)), trimmed_string (p.substring (1, i - 1)))
				else
					check is_well_formed_parameter: False end
				end
				l_parts.forth
			end

			check quality_initialized_to_1: quality = 1.0 end

				-- Get quality from parameter if any, and format the value as expected.
			if attached item ("q") as q then
				if q.same_string ("1") then
						--| Use 1.0 formatting
					put ("1.0", "q")
				elseif q.is_double and then attached q.to_real_64 as r then
					if r <= 0.0 then
						quality := 0.0 --| Should it be 1.0 ?
					elseif r >= 1.0 then
						quality := 1.0
					else
						quality := r
					end
				else
					put ("1.0", "q")
					quality := 1.0
				end
			else
				put ("1.0", "q")
			end
		end

	make_with_language (a_lang_tag: READABLE_STRING_8)
			-- Instantiate Current from language tag `a_lang_tag'.
		local
			i: INTEGER
		do
			initialize

			create language_range.make_from_string (a_lang_tag)
			i := a_lang_tag.index_of ('-', 1)
			if i > 0 then
				language := a_lang_tag.substring (1, i - 1)
				specialization := a_lang_tag.substring (i + 1, a_lang_tag.count)
			else
				language := a_lang_tag
			end
		ensure
			language_range_set: language_range.same_string (a_lang_tag) and a_lang_tag /= language_range
		end

	make (a_root_lang: READABLE_STRING_8; a_specialization: detachable READABLE_STRING_8)
			-- Instantiate Current with `a_root_lang' and `a_specialization'.
		do
			initialize
			create language_range.make_empty
			language := a_root_lang
			specialization := a_specialization
			update_language_range (a_root_lang, a_specialization)
		end

	make_default
			-- Instantiate Current with default "*" language.
		do
			make ("*", Void)
		end

	initialize
			-- Initialize Current
		do
			create params.make (2)
			quality := 1.0
		end

feature -- Access

	language_range: STRING_8
			-- language-range  = ( ( 1*8ALPHA *( "-" 1*8ALPHA ) ) | "*" )

	language: READABLE_STRING_8
			-- First part of the language range, i.e the root language

	specialization: detachable READABLE_STRING_8
			-- Optional second part of the language range, i.e the dialect, or specialized language type

	quality: REAL_64
			-- Associated quality, by default 1.0

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			create Result.make_from_string (language_range)
			Result.append_character (';')
			Result.append ("q=")
			Result.append_double (quality)
		end

feature -- Parameters

	item (a_key: STRING): detachable STRING
			-- Item associated with `a_key', if present
			-- otherwise default value of type `STRING'
		do
			Result := params.item (a_key)
		end

	keys: LIST [STRING]
			-- arrays of currents keys
		local
			res: ARRAYED_LIST [STRING]
		do
			create res.make_from_array (params.current_keys)
			Result := res
		end

	params: HASH_TABLE [STRING, STRING]
			-- dictionary of all the parameters for the media range

feature -- Status Report

	has_key (a_key: STRING): BOOLEAN
			-- Is there an item in the table with key `a_key'?
		do
			Result := params.has_key (a_key)
		end

feature -- Element change

	set_language (a_root_lang: READABLE_STRING_8)
			-- Set `'anguage' with `a_root_lang'
		require
			a_root_lang_attached: a_root_lang /= Void
		do
			language := a_root_lang
			update_language_range (a_root_lang, specialization)
		ensure
			type_assigned: language ~ a_root_lang
		end

	set_specialization (a_specialization: detachable READABLE_STRING_8)
			-- Set `specialization' with `a_specialization'
		do
			specialization := a_specialization
			update_language_range (language, a_specialization)
		ensure
			specialization_assigned: specialization ~ a_specialization
		end

	put (new: STRING; key: STRING)
			-- Insert `new' with `key' if there is no other item
			-- associated with the same key. If present, replace
			-- the old value with `new'
		do
			if params.has_key (key) then
				params.replace (new, key)
			else
				params.force (new, key)
			end
		ensure
			has_key: params.has_key (key)
			has_item: params.has_item (new)
		end

feature {NONE} -- Implementation		

	update_language_range (a_lang: like language; a_specialization: like specialization)
			-- Update `language_range' with `a_lang' and `a_specialization'
		local
			l_language_range: like language_range
		do
			l_language_range := language_range -- Reuse same object, be careful not to keep reference on existing string at first.
			l_language_range.wipe_out
			l_language_range.append (a_lang)

			if a_specialization /= Void then
				l_language_range.append_character ('-')
				l_language_range.append (a_specialization)
			end
		end

feature {NONE} -- Helper

	trimmed_string (s: READABLE_STRING_8): STRING_8
			-- Copy of `s', where whitespace were stripped from the beginning and end of the string
		do
			create Result.make_from_string (s)
			Result.left_adjust
			Result.right_adjust
		end

invariant
	valid_quality: 0.0 <= quality and quality <= 1.0

note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
