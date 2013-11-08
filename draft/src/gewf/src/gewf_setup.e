note
	description: "[
				Configuration of GEWF tool.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	GEWF_SETUP

inherit
	SHARED_EXECUTION_ENVIRONMENT

create
	make

feature -- Initialization

	make

		do
				--| root_dir
			get_root_dir

				--| template_dir	
			get_template_dir

		end

	get_root_dir
		local
			ut: FILE_UTILITIES
			p: detachable PATH
		do
				--|  either $GEWF, or $HOME/.gewf or cwd/.gewf or cwd
			if attached execution_environment.item ("GEWF") as s then
				create p.make_from_string (s)
			elseif attached execution_environment.item ("HOME") as s then
				create p.make_from_string (s)
				p := p.extended (".gewf")
				create ut
				if not ut.directory_path_exists (p) then
					p := Void
				end
			end
			if p = Void then
				p := execution_environment.current_working_path
				if ut.directory_path_exists (p.extended (".gewf")) then
					p := p.extended (".gewf")
				end
			end
			root_dir := p
		end

	get_template_dir
		do
			if attached execution_environment.item ("GEWF_TEMPLATE_DIR") as tpl_dir then
				create template_dir.make_from_string (tpl_dir)
			else
				template_dir := root_dir.extended ("template")
			end
		end

feature -- Access

	root_dir: PATH

	template_dir: PATH

feature -- Status report

	is_custom_template_dir: BOOLEAN

	is_custom_root_dir: BOOLEAN

feature -- Change

	set_root_dir (p: PATH)
		do
			is_custom_root_dir := True
			root_dir := p
			if not is_custom_template_dir then
					-- update template_dir
				get_template_dir
			end
		end

	set_template_dir_from_string (dn: READABLE_STRING_GENERAL)
		do
			set_template_dir (create {PATH} .make_from_string (dn))
		end

	set_template_dir (p: PATH)
		do
			is_custom_template_dir := True
			template_dir := p
		end

;note
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
