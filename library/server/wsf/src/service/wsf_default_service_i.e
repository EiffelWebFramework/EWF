note
	description: "Summary description for {WSF_DEFAULT_SERVICE_I}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_DEFAULT_SERVICE_I [G -> WSF_SERVICE_LAUNCHER create make_and_launch end]

inherit
	WSF_SERVICE

feature {NONE} -- Initialization

	frozen make_and_launch
		local
			l_launcher: G
		do
			initialize
			create l_launcher.make_and_launch (Current, service_options)
		end

	initialize
			-- Initialize current service
			--| Could be redefine to set custom service option(s)
		do
		end

	service_options: detachable WSF_SERVICE_LAUNCHER_OPTIONS

feature -- Default service options

	set_service_option (a_name: READABLE_STRING_GENERAL; a_value: detachable ANY)
			-- Set options related to WSF_DEFAULT_SERVICE
		local
			opts: like service_options
		do
			opts := service_options
			if opts = Void then
				create opts.make
				service_options := opts
			end
			opts.set_option (a_name, a_value)
		ensure
			attached service_options as l_options and then l_options.option (a_name) = a_value
		end

note
	copyright: "2011-2012, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
