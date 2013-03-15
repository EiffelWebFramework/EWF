note
	description: "Summary description for {WSF_CMS_MODULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_MODULE

feature -- Access

	is_enabled: BOOLEAN

	name: STRING

	description: STRING

	package: STRING

	version: STRING

feature {CMS_SERVICE} -- Registration

	register (a_service: CMS_SERVICE)
		deferred
		end

feature -- Settings

	enable
		do
			is_enabled := True
		end

	disable
		do
			is_enabled := False
		end

feature -- Hooks

	help_text (a_path: STRING): STRING
		do
			Result := ""
		end

	permissions: LIST [TUPLE [title: detachable STRING; description: detachable STRING]]
		do
			create {ARRAYED_LIST [like permissions.item]} Result.make (0)
		end

	links: HASH_TABLE [CMS_MODULE_LINK, STRING]
			-- Link indexed by path
		deferred
		end

end
