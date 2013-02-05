note
	description: "Summary description for {CMS_CONFIGURATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_CONFIGURATION

--inherit
--	SHARED_EXECUTION_ENVIRONMENT

create
	make,
	make_from_file

feature {NONE} -- Initialization

	make
		do
			create options.make (10)
			analyze
		end

	make_from_file (a_filename: READABLE_STRING_32)
			-- Initialize `Current'.
		do
			make
			import (a_filename)
			analyze
		end

	analyze
		do
			get_root_location
			get_var_location
			get_themes_location
			get_files_location
		end

feature -- Access

	option (a_name: READABLE_STRING_GENERAL): detachable ANY
		do
			Result := options.item (a_name.as_string_8)
		end

	options: HASH_TABLE [STRING, STRING]

feature -- Conversion

	append_to_string (s: STRING)
		do
			s.append ("Options:%N")
			across
				options as c
			loop
				s.append (c.key)
				s.append_character ('=')
				s.append (c.key)
				s.append_character ('%N')
			end

			s.append ("Specific:%N")
			s.append ("root_location=" + root_location + "%N")
			s.append ("var_location=" + var_location + "%N")
			s.append ("files_location=" + files_location + "%N")
			s.append ("themes_location=" + themes_location + "%N")
		end

feature -- Element change

	set_option (a_name: READABLE_STRING_GENERAL; a_value: STRING)
		do
			options.force (a_value, a_name.as_string_8)
		end

feature -- Access

	var_location: READABLE_STRING_8

	root_location: READABLE_STRING_8

	files_location: STRING

	themes_location: STRING

	theme_name (dft: detachable like theme_name): READABLE_STRING_8
		do
			if attached options.item ("theme") as s then
				Result := s
			elseif dft /= Void then
				Result := dft
			else
				Result := "default"
			end
		end

	site_name (dft: like site_name): READABLE_STRING_8
		do
			if attached options.item ("site.name") as s then
				Result := s
			else
				Result := dft
			end
		end

	site_url (dft: like site_url): READABLE_STRING_8
		do
			if attached options.item ("site.url") as s then
				Result := s
			else
				Result := dft
			end
			if Result /= Void then
				if Result.is_empty then
				elseif not Result.ends_with ("/") then
					Result := Result + "/"
				end
			end
		end

	site_script_url (dft: like site_script_url): detachable READABLE_STRING_8
		do
			if attached options.item ("site.script_url") as s then
				Result := s
			else
				Result := dft
			end
			if Result /= Void then
				if Result.is_empty then
				elseif not Result.ends_with ("/") then
					Result := Result + "/"
				end
			end
		end

	site_email (dft: like site_email): READABLE_STRING_8
		do
			if attached options.item ("site.email") as s then
				Result := s
			else
				Result := dft
			end
		end

feature -- Change

	get_var_location
		local
			res: STRING_32
		do
			if attached options.item ("var-dir") as s then
				res := s
			else
				res := execution_environment.current_working_directory
			end
			if res.ends_with ("/") then
				res.remove_tail (1)
			end
			var_location := res
		end


	get_root_location
		local
			res: STRING_32
		do
			if attached options.item ("root-dir") as s then
				res := s
			else
				res := execution_environment.current_working_directory
			end
			if res.ends_with ("/") then
				res.remove_tail (1)
			end
			root_location := res
		end

	get_files_location
		do
			if attached options.item ("files-dir") as s then
				files_location := s
			else
				files_location := "files"
			end
		end

	get_themes_location
		local
			dn: DIRECTORY_NAME
		do
			if attached options.item ("themes-dir") as s then
				themes_location := s
			else
				create dn.make_from_string (root_location)
				dn.extend ("themes")
				themes_location := dn.string
			end
		end

feature {NONE} -- Implementation

	import (a_filename: READABLE_STRING_32)
			-- Import ini file content
		local
			f: PLAIN_TEXT_FILE
			l,v: STRING_8
			p: INTEGER
		do
			--FIXME: handle unicode filename here.
			create f.make (a_filename)
			if f.exists and f.is_readable then
				f.open_read
				from
					f.read_line
				until
					f.exhausted
				loop
					l := f.last_string
					l.left_adjust
					if not l.is_empty and then l[1] /= '#' then
						p := l.index_of ('=', 1)
						if p > 1 then
							v := l.substring (p + 1, l.count)
							l.keep_head (p - 1)
							v.left_adjust
							v.right_adjust
							l.right_adjust
							set_option (l.as_lower, v)
						end
					end
					f.read_line
				end
				f.close
			end
		end

feature {NONE} -- Environment

	Execution_environment: EXECUTION_ENVIRONMENT
		once
			create Result
		end

end
