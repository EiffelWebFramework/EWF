note
	description: "Summary description for {WSF_FILTERED_EXECUTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_FILTERED_EXECUTION

inherit
	WSF_EXECUTION
		redefine
			initialize
		end

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			initialize_filter
		end

	initialize_filter
			-- Initialize `filter'
		do
			create_filter
			setup_filter
		end

	create_filter
			-- Create `filter'	
		deferred
		ensure
			filter_created: filter /= Void
		end

	setup_filter
			-- Setup `filter'
		require
			filter_created: filter /= Void
		deferred
		end

	append_filters (a_filters: ITERABLE [WSF_FILTER])
			-- Append collection `a_filters' of filters to the end of the `filter' chain.
		local
			f: like filter
			l_next_filter: detachable like filter
		do
			from
				f := filter
				l_next_filter := f.next
			until
				l_next_filter = Void
			loop
				f := l_next_filter
				l_next_filter := f.next
			end
			check f_attached_without_next: f /= Void and then f.next = Void end
			across
				a_filters as ic
			loop
				l_next_filter := ic.item
				f.set_next (l_next_filter)
				f := l_next_filter
			end
		end

feature -- Access

	filter: WSF_FILTER
			-- Filter

feature -- Execution

	execute
		do
			filter.execute (request, response)
		end

;note
	copyright: "2011-2015, Jocelyn Fiat, Javier Velilla, Olivier Ligot, Colin Adams, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
