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
	PROCESS_FACTORY
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

note
	copyright: "2011-2016, Jocelyn Fiat, Javier Velilla, Olivier Ligot, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
