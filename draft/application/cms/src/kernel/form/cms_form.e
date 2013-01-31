note
	description: "Summary description for {CMS_FORM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_FORM

inherit
	ITERABLE [CMS_FORM_ITEM]

create
	make

feature {NONE} -- Initialization

	make (a_action: READABLE_STRING_8; a_id: READABLE_STRING_8)
		do
			action := a_action
			id := a_id

			create html_classes.make (2)
			create items.make (10)
			set_method_post
		end

feature -- Access

	action: READABLE_STRING_8
			-- URL for the web form

	id: READABLE_STRING_8
			-- Id of the form

	count: INTEGER
		do
			Result := items.count
		end

	method: READABLE_STRING_8
			-- Form's method
			--| GET or POST

feature -- Validation

	validation_action: detachable PROCEDURE [ANY, TUPLE [CMS_FORM_DATA]]
			-- Procedure to validate the data
			-- report error if not valid

--	submit_callbacks_actions: HASH_TABLE [PROCEDURE [ANY, TUPLE [CMS_FORM_DATA]], STRING]
--			-- Submit callbacks indexed by submit names

feature -- Element change

	set_method_get
		do
			method := "GET"
		end

	set_method_post
		do
			method := "POST"
		end

	set_validation_action (act: like validation_action)
		do
			validation_action := act
		end

feature -- Access

	new_cursor: ITERATION_CURSOR [CMS_FORM_ITEM]
			-- Fresh cursor associated with current structure
		do
			Result := items.new_cursor
		end

feature -- Optional

	html_classes: ARRAYED_LIST [STRING_8]

feature -- Items

	has_field (a_name: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := across items as i some attached {CMS_FORM_FIELD} i.item as l_field and then l_field.name.same_string_general (a_name) end
		end

--	items_by_name (a_name: READABLE_STRING_GENERAL): detachable LIST [CMS_FORM_ITEM]
--		local
--			res: detachable ARRAYED_LIST [CMS_FORM_ITEM]
--		do
--			across
--				items as c
--			loop
--				if c.item.name.same_string_general (a_name) then
--					if res = Void then
--						create res.make (1)
--					end
--					res.force (c.item)
--				end
--			end
--			Result := res
--		end

	fields_by_name (a_name: READABLE_STRING_GENERAL): detachable LIST [CMS_FORM_FIELD]
		local
			res: detachable ARRAYED_LIST [CMS_FORM_FIELD]
		do
			across
				items as c
			loop
				if
					attached {CMS_FORM_FIELD} c.item as l_field and then
					l_field.name.same_string_general (a_name)
				then
					if res = Void then
						create res.make (1)
					end
					res.force (l_field)
				end
			end
			Result := res
		end

	extend (i: CMS_FORM_ITEM)
		local
			n: READABLE_STRING_8
		do
			if attached {CMS_FORM_FIELD} i as l_field then
				n := l_field.name
				if n.is_empty then
					n := (items.count + 1).out
					l_field.update_name (n)
				end
			end
			items.force (i)
		end

	extend_text (t: READABLE_STRING_8)
		do
			extend (create {CMS_FORM_RAW_TEXT}.make (t))
		end

feature -- Conversion

	to_html (a_theme: CMS_THEME): STRING_8
		local
			s: STRING
		do
			Result := "<form action=%""+ action +"%" id=%""+ id +"%" method=%""+ method +"%" "
			if not html_classes.is_empty then
				create s.make_empty
				across
					html_classes as cl
				loop
					if not s.is_empty then
						s.extend (' ')
					end
					s.append (cl.item)
				end
				Result.append (" class=%"" + s + "%" ")
			end
			Result.append (">%N")
			across
				items as c
			loop
				Result.append (c.item.to_html (a_theme))
			end
			Result.append ("</form>%N")
		end

feature {NONE} -- Implementation

	items: ARRAYED_LIST [CMS_FORM_ITEM]
			-- name => item

invariant

end
