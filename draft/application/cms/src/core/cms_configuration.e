note
	description: "Summary description for {CMS_CONFIGURATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_CONFIGURATION

create
	make,
	make_from_file

feature {NONE} -- Initialization

	make
		do
			create options.make (10)
		end

	make_from_file (a_filename: READABLE_STRING_32)
			-- Initialize `Current'.
		do
			make
			import (a_filename)
		end

feature -- Access

	option (a_name: READABLE_STRING_GENERAL): detachable ANY
		do
			Result := options.item (a_name.as_string_8)
		end

	options: HASH_TABLE [STRING, STRING]

feature -- Element change

	set_option (a_name: READABLE_STRING_GENERAL; a_value: STRING)
		do
			options.force (a_value, a_name.as_string_8)
		end

feature -- Access

	root_location: STRING
		do
			if attached options.item ("root.location") as s then
				Result := s
			else
				Result := execution_environment.current_working_directory
			end
			if not Result.ends_with ("/") then
				Result.append_character ('/')
			end
		end

	themes_location: STRING
		do
			if attached options.item ("themes.location") as s then
				Result := s
			else
				Result := root_location + "theme/default/"
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

	site_base_url (dft: like site_base_url): detachable READABLE_STRING_8
		do
			if attached options.item ("site.base_url") as s then
				Result := s
			else
				Result := dft
			end
			if Result /= Void then
				if Result.is_empty then
					Result := Void
				elseif not Result.starts_with ("/") then
					Result := "/" + Result
					if Result.ends_with ("/") then
						Result := Result.substring (1, Result.count - 1)
					end
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

feature {NONE} -- Implementation

	execution_environment: EXECUTION_ENVIRONMENT
		once
			create Result
		end

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

end
