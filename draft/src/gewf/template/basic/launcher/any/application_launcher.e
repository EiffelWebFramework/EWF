note
	description: "Summary description for {APPLICATION_LAUNCHER}."
	author: ""
	date: "$Date: 2013-06-12 13:55:42 +0200 (mer., 12 juin 2013) $"
	revision: "$Revision: 36 $"

deferred class
	APPLICATION_LAUNCHER

feature {NONE} -- Initialization

	launcher_nature: detachable READABLE_STRING_8
			-- Initialize the launcher nature
			-- either cgi, libfcgi, or nino.
			--| We could extend with more connector if needed.
			--| and we could use WSF_DEFAULT_SERVICE_LAUNCHER to configure this at compilation time.
		local
			p: PATH
			l_entry_name: READABLE_STRING_32
			ext: detachable READABLE_STRING_32
		do
			create p.make_from_string (execution_environment.arguments.command_name)
			if attached p.entry as l_entry then
				ext := l_entry.extension 
			end
			if ext /= Void then
				if ext.same_string (nature_nino) then
					Result := nature_nino
				end
				if ext.same_string (nature_cgi) then
					Result := nature_cgi
				end
				if ext.same_string (nature_libfcgi) or else ext.same_string ("fcgi") then
					Result := nature_libfcgi
				end
			end
		end

feature {NONE} -- nino		

	nature_nino: STRING = "nino"

	launch_nino (a_service: WSF_SERVICE; opts: detachable WSF_SERVICE_LAUNCHER_OPTIONS)
		do
			create {WSF_NINO_SERVICE_LAUNCHER} launcher.make_and_launch (a_service, opts)
		end

feature {NONE} -- cgi

	nature_cgi: STRING = "cgi"

	launch_cgi (a_service: WSF_SERVICE; opts: detachable WSF_SERVICE_LAUNCHER_OPTIONS)
		do
			create {WSF_CGI_SERVICE_LAUNCHER} launcher.make_and_launch (a_service, opts)
		end

feature {NONE} -- libfcgi

	nature_libfcgi: STRING = "libfcgi"

	launch_libfcgi (a_service: WSF_SERVICE; opts: detachable WSF_SERVICE_LAUNCHER_OPTIONS)
		do
			create {WSF_LIBFCGI_SERVICE_LAUNCHER} launcher.make_and_launch (a_service, opts)
		end

feature {NONE} -- Launcher

	launch (a_service: WSF_SERVICE; opts: detachable WSF_SERVICE_LAUNCHER_OPTIONS)
		local
			nature: like launcher_nature
		do
			nature := launcher_nature
			if nature = Void or else nature = nature_nino then
				launch_nino (a_service, opts)
			elseif nature = nature_cgi then
				launch_cgi (a_service, opts)
			elseif nature = nature_libfcgi then
				launch_libfcgi (a_service, opts)
			else
				-- bye bye
				(create {EXCEPTIONS}).die (-1)
			end
		end

end
