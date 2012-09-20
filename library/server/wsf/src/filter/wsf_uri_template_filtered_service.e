note
	description: "Summary description for {WSF_URI_TEMPLATE_FILTERED_SERVICE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_URI_TEMPLATE_FILTERED_SERVICE

feature {NONE} -- Initialization

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

feature -- Access

	filter: WSF_FILTER
			-- Filter

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
