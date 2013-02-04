note
	description : "[ 
				CMS interface to storage
			]"
	date        : "$Date$"
	revision    : "$Revision$"

deferred class
	CMS_STORAGE

feature {NONE} -- Initialization

	initialize
		do
		end

feature -- Access: user

	has_user: BOOLEAN
			-- Has any user?
		deferred
		end

	fill_user_profile (a_user: CMS_USER)
		deferred
		end

	all_users: LIST [CMS_USER]
		deferred
		end

	user_by_id (a_id: like {CMS_USER}.id): detachable CMS_USER
		require
			a_id > 0
		deferred
		ensure
			same_id: Result /= Void implies Result.id = a_id
			no_password: Result /= Void implies Result.password = Void
		end

	user_by_name (a_name: like {CMS_USER}.name): detachable CMS_USER
		require
			 a_name /= Void and then not a_name.is_empty
		deferred
		ensure
			no_password: Result /= Void implies Result.password = Void
		end

	user_by_email (a_email: like {CMS_USER}.email): detachable CMS_USER
		deferred
		ensure
			no_password: Result /= Void implies Result.password = Void
		end

	is_valid_credential (u, p: READABLE_STRING_32): BOOLEAN
		deferred
		end

	user_has_permission (u: detachable CMS_USER; s: detachable READABLE_STRING_8): BOOLEAN
			-- Anonymous or user `u' has permission for `s' ?
			--| `s' could be "create page",	
		do
			if s = Void then
				Result := True
			elseif s.has_substring ("admin") or s.has_substring ("users") then
				Result := False
			else
				Result := True
			end
		end

feature -- Change: user

	save_user (a_user: CMS_USER)
		deferred
		ensure
			a_user_password_is_encoded: a_user.password = Void
			a_user.has_id
		end

feature -- Email		

	save_email (a_email: CMS_EMAIL)
		deferred
		end

feature -- Log

	recent_logs (a_lower: INTEGER; a_count: INTEGER): LIST [CMS_LOG]
		deferred
		end

	log (a_id: like {CMS_LOG}.id): detachable CMS_LOG
		require
			a_id > 0
		deferred
		end

	save_log (a_log: CMS_LOG)
		deferred
		end

feature -- Node

	recent_nodes (a_lower: INTEGER; a_count: INTEGER): LIST [CMS_NODE]
		deferred
		end

	node (a_id: INTEGER): detachable CMS_NODE
		require
			a_id > 0
		deferred
		end

	save_node (a_node: CMS_NODE)
		deferred
		end

end
