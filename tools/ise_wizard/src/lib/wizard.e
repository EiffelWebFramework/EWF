note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

deferred class
	WIZARD

inherit
	ARGUMENTS

feature {NONE} -- Initialization

	initialize
			-- Initialize `Current'.
		local
			i,n: INTEGER
			s: READABLE_STRING_8
			wizard_directory_name: detachable READABLE_STRING_8
			callback_file_name: detachable READABLE_STRING_8
		do
			create variables.make (5)
			n := argument_count
			if n > 0 then
				from
					i := 1
				until
					i > n
				loop
					s := argument (i)
					if s.same_string ("-callback") or s.same_string ("--callback") then
						i := i + 1
						if i <= n then
							callback_file_name := argument (i)
						end
					elseif wizard_directory_name = Void then
						wizard_directory_name := s
					else
						debug
							io.error.put_string ("Ignoring argument %"" + s + "%"%N")
						end
					end
					i := i + 1
				end
			end
			if wizard_directory_name = Void then
				display_usage (io.error)
				quit ("ERROR: Missing wizard directory name.")
			elseif callback_file_name = Void then
				display_usage (io.error)
				quit ("ERROR: Missing Eiffel Studio callback file name.")
			else
				create layout.make (wizard_directory_name, callback_file_name)
			end
		end

feature -- Status

	display_usage (f: FILE)
		do
			f.put_string ("Usage: wizard {dirname} -callback {filename}%N")
			f.put_string ("       -callback filename: file used to communicate back with Eiffel Studio%N")
			f.put_string ("        dirname: folder containing the wizard resources, pixmaps, ...%N")
		end

	quit (m: detachable READABLE_STRING_8)
		do
			if m /= Void then
				io.error.put_string (m)
			end
			send_response (create {WIZARD_FAILED_RESPONSE})
		ensure
			False -- never reached
		end

	die (code: INTEGER)
		do
			(create {EXCEPTIONS}).die (code)
		end

feature -- Access

	variables: HASH_TABLE [READABLE_STRING_8, READABLE_STRING_8]

	layout: detachable WIZARD_LAYOUT

feature -- Response	

	send_response (res: WIZARD_RESPONSE)
		local
			f: RAW_FILE
		do
			if attached layout as lay then
				create f.make (lay.callback_file_name)
				if not f.exists or else f.is_writable then
					f.open_write
					res.send (f)
					f.close
				else
					die (0)
				end
			else
				die (0)
			end
		end

feature {NONE} -- Implementation

	boolean_question (m: READABLE_STRING_8; a_options: detachable ITERABLE [TUPLE [key: READABLE_STRING_8; value: BOOLEAN]]; def: detachable STRING_8): BOOLEAN
		local
			s: STRING_8
			l_answered: BOOLEAN
			l_options: detachable ITERABLE [TUPLE [key: READABLE_STRING_8; value: BOOLEAN]]
		do
			from
			until
				l_answered
			loop
				io.put_string (m)
				if l_options = Void then
					l_options := a_options
				end
				if l_options = Void then
					l_options := <<["y", True], ["Y", True]>>
				end
				io.read_line
				s := io.last_string
				s.left_adjust
				s.right_adjust
				if s.is_empty and def /= Void then
					s := def
				end
				if not s.is_empty then
					across
						l_options as o
					until
						l_answered
					loop
						if o.item.key.same_string (s) then
							l_answered := True
							Result := o.item.value
						end
					end
					if not l_answered then
						l_answered := True
						Result := False
					end
				end
			end
		end

	string_question (m: READABLE_STRING_8; a_options: detachable ITERABLE [TUPLE [key: READABLE_STRING_8; value: detachable READABLE_STRING_8]]; def: detachable READABLE_STRING_8; a_required_valid_option: BOOLEAN): detachable READABLE_STRING_8
		local
			s: STRING_8
			l_answered: BOOLEAN
		do
			from
			until
				l_answered
			loop
				io.put_string (m)
				io.read_line
				s := io.last_string
				s.left_adjust
				s.right_adjust
				if s.is_empty and def /= Void then
					s := def
				end
				if not s.is_empty then
					if a_options /= Void then
						across
							a_options as o
						until
							l_answered
						loop
							if o.item.key.same_string (s) then
								l_answered := True
								Result := o.item.value
							end
						end
					end
					if not l_answered then
						l_answered := True
						Result := s
						if
							a_required_valid_option and then
							a_options /= Void and then
							not across a_options as o some attached o.item.value as v and then Result.same_string (v) end
						then
							l_answered := False
							Result := Void
						end
					end
				end
			end
		end

	copy_file (a_src, a_target: READABLE_STRING_8)
		local
			f,t: RAW_FILE
		do
			create f.make (a_src)
			if f.exists and f.is_readable then
				create t.make (a_target)
				if not t.exists or else t.is_writable then
					f.open_read
					t.open_write
					f.copy_to (t)
					t.close
					f.close
				end
			end
		end

	new_uuid: STRING_8
		local
			gen: UUID_GENERATOR
		do
			create gen
			Result := gen.generate_uuid.out
		end

feature -- Resources

	copy_resource (a_res: READABLE_STRING_8; a_target: READABLE_STRING_8)
		do
			if attached layout as lay then
				copy_file (lay.resource (a_res), a_target)
			end
		end

	copy_resource_template (a_res: READABLE_STRING_8; a_target: READABLE_STRING_8)
		local
			f,t: RAW_FILE
		do
			if attached layout as lay then
				create f.make (lay.resource (a_res))
				if f.exists and f.is_readable then
					create t.make (a_target)
					if not t.exists or else t.is_writable then
						f.open_read
						t.create_read_write
						from
							f.read_line
						until
							f.exhausted
						loop
							across
								variables as v
							loop
								f.last_string.replace_substring_all ("${WIZ:" + v.key + "}", v.item)
							end
							t.put_string (f.last_string)
							t.put_new_line
							f.read_line
						end
						t.close
						f.close
					end
				end
			end
		end

end
