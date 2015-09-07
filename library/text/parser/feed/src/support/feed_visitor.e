note
	description: "Summary description for {FEED_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	FEED_VISITOR

feature -- Visit

	visit_feed (a_feed: FEED)
		deferred
		end

	visit_link (a_link: FEED_LINK)
		deferred
		end

	visit_entry (a_entry: FEED_ENTRY)
		deferred
		end

	visit_author (a_author: FEED_AUTHOR)
		deferred
		end

end
