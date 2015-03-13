note
	description: "Summary description for {CONCURRENT_POOL_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CONCURRENT_POOL_FACTORY [G -> CONCURRENT_POOL_ITEM]

feature -- Access

	new_separate_item: separate G
		deferred
		end

note
	copyright: "2011-2013, Javier Velilla, Jocelyn Fiat and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
