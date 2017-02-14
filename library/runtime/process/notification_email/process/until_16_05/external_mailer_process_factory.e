note
	description: "[
			Objects that ...
		]"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	EXTERNAL_MAILER_PROCESS_FACTORY

inherit
	BASE_PROCESS_FACTORY
		redefine
			process_launcher,
			process_launcher_with_command_line
		end

feature -- Access

	process_launcher (a_file_name: READABLE_STRING_GENERAL; args: detachable LIST [READABLE_STRING_GENERAL]; a_working_directory: detachable READABLE_STRING_GENERAL): EXTERNAL_MAILER_PROCESS
			-- Returns a process launcher used to launch program `a_file_name' with arguments `args'
			-- and working directory `a_working_directory'.
			-- Use Void for `a_working_directory' if no working directory is specified.
			-- Use Void for `args' if no arguments are required.			
		do
			create {EXTERNAL_MAILER_PROCESS} Result.make (a_file_name, args, a_working_directory)
		end

	process_launcher_with_command_line (a_cmd_line: READABLE_STRING_GENERAL; a_working_directory: detachable READABLE_STRING_GENERAL): EXTERNAL_MAILER_PROCESS
			-- Returns a process launcher to launch command line `cmd_line' that specifies an executable and
			-- optional arguments, using `a_working_directory' as its working directory.
			-- Use Void for `a_working_directory' if no working directory is required.		
		do
			create {EXTERNAL_MAILER_PROCESS} Result.make_with_command_line (a_cmd_line, a_working_directory)
		end

end
