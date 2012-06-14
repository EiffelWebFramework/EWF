note
	description: "[
					Object that is use in relation with WSF_ROUTER, to precise which request methods is accepted.
					For convenience, `make_from_iterable' is available, so that you can use <<"GET", "POST">> for instance
					but remember manifest string are evil ... 
					Since in HTTP you can use your own custom request method, this is not possible to catch any typo
					 ( for instance if you write "POST" instead of "P0ST" this is hard to find the error, 
					   but in one case it uses upper "o" and in the other case this is zero "0"
					 )
					   
					The recommanded way to use is for instance
					    create {WSF_ROUTER_METHODS}.make_get_post
					    create methods; methods.enable_get; methods.enable_post
					
					This sounds heavy, but this is much safer. 
					
					( note: in addition internally this first checks using reference comparison
					  and then compare string value, so it brings optimization for accepted request methods.
					)
			]"
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_ROUTER_METHODS

inherit
	ITERABLE [READABLE_STRING_8]
		redefine
			default_create
		end

	HTTP_REQUEST_METHODS
		redefine
			default_create
		end

create
	default_create,
	make,
	make_from_iterable,
	make_from_string

convert
	to_array: {ARRAY [READABLE_STRING_8]},
	make_from_iterable ({ITERABLE [READABLE_STRING_8], ITERABLE [STRING_8], ARRAY [READABLE_STRING_8], ARRAY [STRING_8]}),
	make_from_string ({READABLE_STRING_8, STRING_8})

feature {NONE} -- Initialization

	default_create
		do
			Precursor
			make (1)
		end

	make (n: INTEGER)
		do
			create methods.make (n)
		end

	make_from_iterable (v: ITERABLE [READABLE_STRING_8])
		do
			make (1)
			across
				v as vc
			loop
				add_method_using_constant (vc.item)
			end
		end

	make_from_string (v: READABLE_STRING_8)
		do
			make_from_iterable (v.split (','))
		end

feature -- Status report

	is_locked: BOOLEAN
			-- Is Current locked? And then can not be modified?

	is_empty: BOOLEAN
		do
			Result := methods.count = 0
		end

	has (a_method: READABLE_STRING_8): BOOLEAN
			-- Has `a_method' enabled?
		require
			a_method_is_uppercase: a_method.same_string (a_method.as_upper)
		do
			-- First look for string object itself,
			-- in case `a_method' comes from one of the HTTP_REQUEST_METHODS constants
			Result := across methods as c some c.item = a_method end
			if not Result then
				-- If not found, look for the same string value
				Result := across methods as c some c.item.same_string_general (a_method) end
			end
		end

feature -- Access

	new_cursor: ITERATION_CURSOR [READABLE_STRING_8]
			-- Fresh cursor associated with current structure
		do
			Result := methods.new_cursor
		end

feature -- Status change

	lock
			-- Lock current and prevent any change in methods
			-- Once it is locked, it is impossible to unlock.
		do
			is_locked := True
		end

feature -- Element change

	enable_get
		require
			is_not_locked: not is_locked
			get_disabled: not has (method_get)
		do
			methods.extend (method_get)
		ensure
			get_enabled: has (method_get)
		end

	disable_get
		require
			is_not_locked: not is_locked
			get_enabled: has (method_get)
		do
			prune_method (method_get)
		ensure
			get_disabled: not has (method_get)
		end

	enable_post
		require
			is_not_locked: not is_locked
			post_disabled: not has (method_post)
		do
			methods.extend (method_post)
		ensure
			post_enabled: has (method_post)
		end

	disable_post
		require
			is_not_locked: not is_locked
			post_enabled: has (method_post)
		do
			prune_method (method_post)
		ensure
			post_disabled: not has (method_post)
		end

	enable_put
		require
			is_not_locked: not is_locked
			put_disabled: not has (method_put)
		do
			methods.extend (method_put)
		ensure
			put_enabled: has (method_put)
		end

	disable_put
		require
			is_not_locked: not is_locked
			put_enabled: has (method_put)
		do
			prune_method (method_put)
		ensure
			put_disabled: not has (method_put)
		end

	enable_delete
		require
			is_not_locked: not is_locked
			delete_disabled: not has (method_delete)
		do
			methods.extend (method_delete)
		ensure
			delete_enabled: has (method_delete)
		end

	disable_delete
		require
			is_not_locked: not is_locked
			delete_enabled: has (method_delete)
		do
			prune_method (method_delete)
		ensure
			delete_disabled: not has (method_delete)
		end

	enable_options
		require
			is_not_locked: not is_locked
			options_disabled: not has (method_options)
		do
			methods.extend (method_options)
		ensure
			options_enabled: has (method_options)
		end

	disable_options
		require
			is_not_locked: not is_locked
			options_enabled: has (method_options)
		do
			prune_method (method_options)
		ensure
			options_disabled: not has (method_options)
		end

	enable_head
		require
			is_not_locked: not is_locked
			head_disabled: not has (method_head)
		do
			methods.extend (method_head)
		ensure
			head_enabled: has (method_head)
		end

	disable_head
		require
			is_not_locked: not is_locked
			head_enabled: has (method_head)
		do
			prune_method (method_head)
		ensure
			head_disabled: not has (method_head)
		end

	enable_trace
		require
			is_not_locked: not is_locked
			trace_disabled: not has (method_trace)
		do
			methods.extend (method_trace)
		ensure
			trace_enabled: has (method_trace)
		end

	disable_trace
		require
			is_not_locked: not is_locked
			trace_enabled: has (method_trace)
		do
			prune_method (method_trace)
		ensure
			trace_disabled: not has (method_trace)
		end

	enable_connect
		require
			is_not_locked: not is_locked
			connect_disabled: not has (method_connect)
		do
			methods.extend (method_connect)
		ensure
			connect_enabled: has (method_connect)
		end

	disable_connect
		require
			is_not_locked: not is_locked
			connect_enabled: has (method_connect)
		do
			prune_method (method_connect)
		ensure
			connect_disabled: not has (method_connect)
		end

	enable_patch
		require
			is_not_locked: not is_locked
			patch_disabled: not has (method_patch)
		do
			methods.extend (method_patch)
		ensure
			patch_enabled: has (method_patch)
		end

	disable_patch
		require
			is_not_locked: not is_locked
			patch_enabled: has (method_patch)
		do
			prune_method (method_patch)
		ensure
			patch_disabled: not has (method_patch)
		end

	enable_custom (m: READABLE_STRING_8)
		require
			is_not_locked: not is_locked
			not_blank: not across m as mc some mc.item.is_space end
			custom_disabled: not has (m.as_upper)
		do
			methods.extend (m.as_upper)
		ensure
			custom_enabled: has (m.as_upper)
		end

	disable_custom (m: READABLE_STRING_8)
		require
			is_not_locked: not is_locked
			not_blank: not across m as mc some mc.item.is_space end
			custom_enabled: has (m.as_upper)
		do
			prune_method (m.as_upper)
		ensure
			custom_disabled: not has (m.as_upper)
		end

feature -- Access

	methods: ARRAYED_LIST [READABLE_STRING_8]

	to_array: ARRAY [READABLE_STRING_8]
		do
			Result := methods.to_array
		end

feature {NONE} -- Implementation

	add_method_using_constant (v: READABLE_STRING_8)
			-- Add method `v' using method_* constant
		do
			if v.is_case_insensitive_equal (method_get) then
				enable_get
			elseif v.is_case_insensitive_equal (method_post) then
				enable_post
			elseif v.is_case_insensitive_equal (method_put) then
				enable_put
			elseif v.is_case_insensitive_equal (method_delete) then
				enable_delete
			elseif v.is_case_insensitive_equal (method_head) then
				enable_head
			elseif v.is_case_insensitive_equal (method_options) then
				enable_options
			elseif v.is_case_insensitive_equal (method_trace) then
				enable_trace
			elseif v.is_case_insensitive_equal (method_connect) then
				enable_connect
			elseif v.is_case_insensitive_equal (method_patch) then
				enable_patch
			else
				enable_custom (v)
			end
		ensure
			method_set: has (v.as_upper)
		end

	add_method (v: READABLE_STRING_8)
		require
			is_upper_case: v.same_string (v.as_upper)
		do
			if not is_locked then
				methods.extend (v)
			end
		end

	prune_method (v: READABLE_STRING_8)
		require
			is_upper_case: v.same_string (v.as_upper)
		local
			m: READABLE_STRING_8
		do
			if not is_locked then
				from
					methods.start
				until
					methods.after
				loop
					m := methods.item
					if m = v or else m.same_string (v) then
						methods.remove
					else
						methods.forth
					end
				end
			end
		end

invariant
	methods_are_uppercase: across methods as c all c.item.same_string (c.item.as_upper) end

;note
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
