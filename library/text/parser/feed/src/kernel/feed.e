note
	description: "Summary description for {FEED}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FEED

inherit
	FEED_HELPERS

create
	make

feature {NONE} -- Initialization	

	make (a_title: READABLE_STRING_GENERAL)
		do
			create title.make_from_string_general (a_title)
			create entries.make (1)
			create links.make (1)
		end

feature -- Access

	title: IMMUTABLE_STRING_32
			-- Title of the feed/channel.

	description: detachable IMMUTABLE_STRING_32
			-- Associated description/subtitle.

	id: detachable IMMUTABLE_STRING_32
			-- Id associated with Current feed if any.

	date: detachable DATE_TIME
			-- Build date.

	links: STRING_TABLE [FEED_LINK]
			-- Url indexed by relation

	entries: ARRAYED_LIST [FEED_ENTRY]
			-- List of feed items.

feature -- Element change	

	set_description (a_description: detachable READABLE_STRING_GENERAL)
		do
			if a_description = Void then
				description := Void
			else
				create description.make_from_string_general (a_description)
			end
		end

	set_id (a_id: detachable READABLE_STRING_GENERAL)
		do
			if a_id = Void then
				id := Void
			else
				create id.make_from_string_general (a_id)
			end
		end

	set_updated_date_with_text (a_date_text: detachable READABLE_STRING_32)
		do
			if a_date_text = Void then
				date := Void
			else
				date := date_time (a_date_text)
			end
		end

	add_entry (e: FEED_ENTRY)
		do
			entries.force (e)
		end

feature -- Visitor

	accept (vis: FEED_VISITOR)
		do
			vis.visit_feed (Current)
		end

invariant

end
