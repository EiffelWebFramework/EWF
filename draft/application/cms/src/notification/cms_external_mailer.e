note
	description : "Objects that ..."
	author      : "$Author$"
	date        : "$Date$"
	revision    : "$Revision$"

class
	CMS_EXTERNAL_MAILER

inherit
	CMS_MAILER

	SHARED_EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make (a_exe: READABLE_STRING_GENERAL; args: detachable ITERABLE [READABLE_STRING_GENERAL])
			-- Initialize `Current'.
		do
			set_parameters (create {PATH}.make_from_string (a_exe), args)
		end

	executable_path: PATH

	arguments: detachable ARRAYED_LIST [READABLE_STRING_GENERAL]

	stdin_mode_set: BOOLEAN
			-- Use `stdin' to pass email message, rather than using local file?

	stdin_termination_sequence: detachable STRING
			-- Termination sequence for the stdin mode
			--| If any, this tells the executable all the data has been provided
			--| For instance, using sendmail, you should have "%N.%N%N"

feature -- Status

	is_available: BOOLEAN
		local
			f: RAW_FILE
		do
			create f.make_with_path (executable_path)
			Result := f.exists
		end

feature -- Change

	set_parameters (p: like executable_path; args: detachable ITERABLE [READABLE_STRING_GENERAL])
			-- Set parameters `executable_path' and associated `arguments'
		local
			l_args: like arguments
		do
			executable_path := p
			if args = Void then
				arguments := Void
			else
				create l_args.make (5)
				across
					args as c
				loop
					l_args.force (c.item)
				end
				arguments := l_args
			end
		end

	set_stdin_mode (b: BOOLEAN; v: like stdin_termination_sequence)
			-- Set the `stdin_mode_set' value
			-- and provide optional termination sequence when stdin mode is selected.
		do
			stdin_mode_set := b
			stdin_termination_sequence := v
		end

feature -- Basic operation

	process_email (a_email: CMS_EMAIL)
		local
			l_factory: PROCESS_FACTORY
			args: like arguments
			p: detachable PROCESS
			retried: INTEGER
		do
			if retried = 0 then
				create l_factory
				if stdin_mode_set then
					p := l_factory.process_launcher (executable_path.name, arguments, Void)
					p.set_hidden (True)
					p.set_separate_console (False)

					p.redirect_input_to_stream
					p.launch
					if p.launched then
						p.put_string (a_email.message)
						if attached stdin_termination_sequence as v then
							p.put_string (v)
						end
					end
				else
					if attached arguments as l_args then
						args := l_args.twin
					else
						if attached {RAW_FILE} new_temporary_file (generator) as f then
							f.create_read_write
							f.put_string (a_email.message)
							f.close
							create args.make (1)
							args.force (f.path.name)
						end
					end
					p := l_factory.process_launcher (executable_path.name, args, Void)
					p.set_hidden (True)
					p.set_separate_console (False)

					p.launch
				end
				if p.launched and not p.has_exited then
					p.wait_for_exit_with_timeout (1_000_000)
					if not p.has_exited then
						p.terminate
						if not p.has_exited then
							p.wait_for_exit_with_timeout (1_000_000)
						end
					end
				end
			elseif retried = 1 then
				if p /= Void and then p.launched and then not p.has_exited then
					p.terminate
					if not p.has_exited then
						p.wait_for_exit_with_timeout (1_000_000)
					end
				end
			end
		rescue
			retried := retried + 1
			retry
		end

feature {NONE} -- Implementation

	new_temporary_file (a_extension: detachable READABLE_STRING_GENERAL): RAW_FILE
			-- Create file with temporary name.
			-- With concurrent execution, noting ensures that {FILE_NAME}.make_temporary_name is unique
			-- So using `a_extension' may help
		local
			tmp: FILE_NAME
			fn: PATH
			s: STRING
			f: detachable like new_temporary_file
			i: INTEGER
		do
				-- With concurrent execution, nothing ensures that {FILE_NAME}.make_temporary_name is unique
				-- So let's try to find
			from
				create tmp.make_temporary_name
			until
				f /= Void or i > 1000
			loop
				create fn.make_from_string (tmp.string)
				if i > 0 then
					create s.make (3)
					s.append_character ('-')
					s.append_integer (i)
					fn := fn.appended (s)
				end
				if a_extension /= Void then
					fn := fn.appended_with_extension (a_extension)
				end
				create f.make_with_path (fn)
				if f.exists then
					i := i + 1
					f := Void
				end
			end
			if f = Void then
				Result := new_temporary_file (Void)
			else
				Result := f
				check not_temporary_file_exists: not Result.exists end
				check temporary_creatable: Result.is_creatable end
			end
		ensure
			not_result_exists: not Result.exists
			result_creatable: Result.is_creatable
		end

end
