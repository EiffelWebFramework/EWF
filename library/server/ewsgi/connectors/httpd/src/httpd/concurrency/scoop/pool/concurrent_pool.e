note
	description: "Summary description for {CONCURRENT_POOL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONCURRENT_POOL [G -> CONCURRENT_POOL_ITEM]

inherit
	HTTPD_DEBUG_FACILITIES

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			capacity := n
			create items.make_empty (n)
--			create busy_items.make_filled (False, n)
			create busy_items.make_empty (n)
		end

feature -- Access

	count: INTEGER

	is_full: BOOLEAN
		do
			Result := count >= capacity
		end

	is_empty: BOOLEAN
		do
			Result := count = 0
		end

	capacity: INTEGER

	stop_requested: BOOLEAN

feature -- Access

	separate_item (a_factory: separate CONCURRENT_POOL_FACTORY [G]): detachable separate G
		require
			is_not_full: not is_full
		local
			i,n,pos: INTEGER
			lst: like busy_items
			l_item: detachable separate G
		do
			if not stop_requested then
				from
					lst := busy_items
					pos := -1
					i := 0
					n := lst.count - 1
				until
					i > n or l_item /= Void or pos >= 0
				loop
					if not lst [i] then -- is free (i.e not busy)
						pos := i

						if items.valid_index (pos) then
							l_item := items [pos]
							if l_item /= Void then
								busy_items [pos] := True
							end
						end
						if l_item = Void then
								-- Empty, then let's create one.
							l_item := a_factory.new_separate_item
							register_item (l_item)
							items [pos] := l_item
						end
					end
					i := i + 1
				end
				if l_item = Void then
						-- Pool is FULL ...
					check overcapacity: False end
				else
					debug ("pool", "dbglog")
						dbglog ("Lock pool item #" + pos.out + " (free:"+ (capacity - count).out +"))")
					end
					count := count + 1
					busy_items [pos] := True
					Result := l_item
				end
			end
		end

feature -- Basic operation

	gracefull_stop
		do
			stop_requested := True
		end

feature {NONE} -- Internal

	items: SPECIAL [detachable separate G]

	busy_items: SPECIAL [BOOLEAN]

feature {CONCURRENT_POOL_ITEM} -- Change

	release_item (a_item: separate G)
			-- Unregister `a_item' from Current pool.
		require
			count > 0
		local
			i,n,pos: INTEGER
			lst: like items
		do
				-- release handler for reuse
			from
				lst := items
				i := 0
				n := lst.count - 1
			until
				i > n or lst [i] = a_item
			loop
				i := i + 1
			end
			if i <= n then
				pos := i
				busy_items [pos] := False
				count := count - 1
--reuse				items [pos] := Void
				debug ("pool", "dbglog")
					dbglog ("Released pool item #" + i.out + " (free:"+ (capacity - count).out +"))")
				end
			else
				check known_item: False end
			end
		end

feature -- Change

	set_count (n: INTEGER)
		local
			g: detachable separate G
		do
			capacity := n
			items.fill_with (g, 0, n - 1)
			busy_items.fill_with (False, 0, n - 1)
		end

	terminate
		local
			l_items: like items
		do
			l_items := items
			l_items.wipe_out
		end

feature {NONE} -- Implementation

--	new_separate_item: separate G
--		deferred
--		end

	register_item (a_item: separate G)
		do
			a_item.set_pool (Current)
		end

note
	copyright: "2011-2014, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
