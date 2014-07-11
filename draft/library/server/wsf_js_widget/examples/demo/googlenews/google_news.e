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
			if attached {JSON_STRING} json.item ("title") as l_title then
				title := l_title.unescaped_string_32
			end
			if attached {JSON_STRING} json.item ("content") as l_content then
				content := l_content.unescaped_string_32
			end
			if
				attached {JSON_OBJECT} json.item ("image") as img and then
				attached {JSON_STRING} img.item ("url") as l_image
			then
				image := l_image.unescaped_string_32
			end
		end

feature -- Access

	title: detachable STRING_32

	content: detachable STRING_32

	image: detachable STRING_32

	item  alias "[]"  (a_field: READABLE_STRING_GENERAL): detachable ANY
			-- <Precursor>
		do
			if a_field.same_string ("title") then
				Result := title
			elseif a_field.same_string ("content") then
				Result := content
			elseif a_field.same_string ("image") then
				Result := image
			end
		end

end
