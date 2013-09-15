note
	description: "Summary description for {GOOGLE_NEWS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GOOGLE_NEWS

inherit

	WSF_ENTITY

create
	make_from_json

feature {NONE}

	make_from_json (json: JSON_OBJECT)
		do
			if attached {JSON_STRING} json.item (create {JSON_STRING}.make_json ("title")) as a_title then
				title := a_title.unescaped_string_32
			end
			if attached {JSON_STRING} json.item (create {JSON_STRING}.make_json ("content")) as a_content then
				content := a_content.unescaped_string_32
			end
			if attached {JSON_OBJECT} json.item (create {JSON_STRING}.make_json ("image")) as img and then attached {JSON_STRING} img.item (create {JSON_STRING}.make_json ("url")) as a_image then
				image := a_image.item
			end
		end

feature

	title: detachable STRING

	content: detachable STRING

	image: detachable STRING

	get (field: STRING): detachable ANY
		do
			if field.is_equal ("title") then
				Result := title
			elseif field.is_equal ("content") then
				Result := content
			elseif field.is_equal ("image") then
				Result := image
			end
		end

end
