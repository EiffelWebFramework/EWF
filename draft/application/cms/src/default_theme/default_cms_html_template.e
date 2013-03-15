note
	description: "Summary description for {CMS_HTML_TEMPLATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEFAULT_CMS_HTML_TEMPLATE

inherit
	CMS_HTML_TEMPLATE

create
	make

feature {NONE} -- Initialization

	make (t: DEFAULT_CMS_THEME)
		do
			theme := t
			create variables.make (0)
		end

	variables: HASH_TABLE [detachable ANY, STRING]

feature -- Access

	register (v: STRING_8; k: STRING_8)
		do
			variables.force (v, k)
		end

	theme: DEFAULT_CMS_THEME

	prepare (page: CMS_HTML_PAGE)
		do
			variables.make (10)
			if attached page.title as l_title then
				variables.force (l_title, "title")
				variables.force (l_title, "head_title")
			else
				variables.force ("", "title")
				variables.force ("", "head_title")
			end

			variables.force (page.language, "language")
			variables.force (page.head_lines_to_string, "head_lines")
		end

	to_html (page: CMS_HTML_PAGE): STRING
		do
			-- Process html generation
			create Result.make_from_string (template)
			apply_template_engine (Result)
		end

feature {NONE} -- Implementation

	template: STRING
		once
			Result := "[
				<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML+RDFa 1.0//EN" "http://www.w3.org/MarkUp/DTD/xhtml-rdfa-1.dtd">
				<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="$language" lang="$language" version="XHTML+RDFa 1.0" dir="ltr">
				<head>
				$head
				<title>$head_title</title>
				$styles
				$scripts
				$head_lines
				</head>
				<body class="$body_classes" $body_attributes>
				$page_top
				$page
				$page_bottom
				</body>
				</html>
			]"
		end


end
