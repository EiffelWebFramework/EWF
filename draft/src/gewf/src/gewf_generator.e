note
	description: "Summary description for {GEWF_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GEWF_GENERATOR

inherit
	DIRECTORY_ITERATOR
		redefine
			process_directory,
			process_file
		end

create
	make

feature {NONE} -- Initialization

	make (tpl: PATH; tgt: PATH)
		do
			template_folder := tpl
			target_folder := tgt
		end

feature -- Execution

	execute (vals: STRING_TABLE [READABLE_STRING_8])
		do
			values := vals
			process_directory (template_folder)
			values := Void
		end

feature -- Operation

	process_file (fn: PATH)
			-- <Precursor>
		local
			s: STRING_32
			line: STRING
			src,tgt: RAW_FILE
		do
			create s.make_from_string (fn.name)
			s := s.substring (template_folder.name.count + 2, s.count)
			if attached fn.extension as ext and then ext.is_case_insensitive_equal ("tpl") then
				s.remove_tail (4) -- ".tpl"
			end

			evaluate_string_32 (s)
			s.to_lower
			create src.make_with_path (fn)
			create tgt.make_with_path (target_folder.extended (s))
			tgt.create_read_write
			src.open_read
			from
			until
				src.exhausted
			loop
				src.read_line_thread_aware
				line := src.last_string
				evaluate_string_8 (line)
				tgt.put_string (line)
				tgt.put_new_line
			end
			src.close
			tgt.close

--			Precursor (fn)
		end

	process_directory (dn: PATH)
			-- <Precursor>
		local
			s: STRING_32
			p: PATH
			dir: DIRECTORY
		do
			create s.make_from_string (dn.name)
			s := s.substring (template_folder.name.count + 1, s.count)
			evaluate_string_32 (s)
			p := target_folder.extended (s)
			create dir.make_with_path (p)
			dir.recursive_create_dir
			Precursor (dn)
		end

feature -- Access

	values: detachable STRING_TABLE [READABLE_STRING_8]

	template_folder: PATH
	target_folder: PATH

feature -- Implementation

	evaluate_string_8 (s: STRING_8)
		do
			if attached values as l_values then
				across
					l_values as c
				loop
					s.replace_substring_all ({STRING_8} "${" + c.key.as_string_8 + "}", c.item)
				end
			end
		end

	evaluate_string_32 (s: STRING_32)
		do
			if attached values as l_values then
				across
					l_values as c
				loop
					s.replace_substring_all ({STRING_32} "${" + c.key.as_string_32 + "}", c.item)
				end
			end
		end


note
	copyright: "2011-2013, Jocelyn Fiat, Javier Velilla, Olivier Ligot, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
