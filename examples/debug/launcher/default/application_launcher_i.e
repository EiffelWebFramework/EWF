note
	description: "[
			Specific application launcher

			DO NOT EDIT THIS CLASS

			you can customize APPLICATION_LAUNCHER
		]"
	date: "$Date: 2013-06-12 13:55:42 +0200 (mer., 12 juin 2013) $"
	revision: "$Revision: 36 $"

deferred class
	APPLICATION_LAUNCHER_I

feature -- Execution

	launch (a_service: WSF_SERVICE; opts: detachable WSF_SERVICE_LAUNCHER_OPTIONS)
		local
			launcher: WSF_SERVICE_LAUNCHER
		do
			create {WSF_DEFAULT_SERVICE_LAUNCHER} launcher.make_and_launch (a_service, opts)
		end

end


