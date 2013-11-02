note
	description: "Summary description for {GOOGLE_NEWS_REPEATER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GOOGLE_NEWS_REPEATER

inherit

	WSF_REPEATER_CONTROL [GOOGLE_NEWS]

create
	make

feature

	render_item (item: GOOGLE_NEWS): STRING
		local
			body: STRING
		do
			Result := ""
			if attached item.image as image then
				Result.append (render_tag_with_tagname ("a", render_tag_with_tagname ("img", "", "style=%"max-width: 200px;%" src=%"" + image + "%"", "media-object"), "href=%"#%"", "pull-left"))
			end
			body := ""
			if attached item.title as title then
				body.append (render_tag_with_tagname ("h4", title, "", "media-heading"))
			end
			if attached item.content as content then
				body.append (content)
			end
			Result.append (render_tag_with_tagname ("div", body, "", "media-body"))
			Result := render_tag_with_tagname ("div", Result, "", "media") + "<hr />"
		end

end
