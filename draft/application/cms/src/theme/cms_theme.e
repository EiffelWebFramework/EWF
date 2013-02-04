note
	description: "Summary description for {WSF_CMS_THEME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_THEME

inherit
	CMS_COMMON_API

feature {NONE} -- Access

	service: CMS_SERVICE
		deferred
		end

feature -- Access

	name: STRING
		deferred
		end

	regions: ARRAY [STRING]
		deferred
--			Result := <<"header", "content", "footer">>
		end

	page_template: CMS_TEMPLATE
		deferred
		end

feature -- Conversion

	menu_html (a_menu: CMS_MENU; is_horizontal: BOOLEAN): STRING_8
		do
			create Result.make_from_string ("<div id=%""+ a_menu.name +"%">")
			if is_horizontal then
				Result.append ("<ul class=%"horizontal%" >%N")
			else
				Result.append ("<ul class=%"vertical%" >%N")
			end
			across
				a_menu as c
			loop
				if c.item.is_active then
					Result.append ("<li class=%"active%">")
				else
					Result.append ("<li>")
				end
				Result.append ("<a href=%"" + url (c.item.location, c.item.options) + "%">" + html_encoded (c.item.title) + "</a></li>")
			end
			Result.append ("</ul>%N")
			Result.append ("</div>")
		end

	page_html (page: CMS_HTML_PAGE): STRING_8
		deferred
		end

end
