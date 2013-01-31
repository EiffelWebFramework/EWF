note
	description: "Summary description for {CMS_PAGE_TEMPLATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEFAULT_CMS_PAGE_TEMPLATE

inherit
	CMS_PAGE_TEMPLATE

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

	theme: DEFAULT_CMS_THEME

	prepare  (page: CMS_HTML_PAGE)
		do
			variables.make (10)

			if attached page.title as l_title then
				variables.force (l_title, "title")
			else
				variables.force ("", "title")
			end
			across
				theme.regions as r
			loop
				variables.force (page.region (r.item), r.item)
			end
		end

	to_html (page: CMS_HTML_PAGE): STRING
		do
			-- Process html generation
			create Result.make_from_string (template)
			apply_template_engine (Result)
		end

feature -- Registration

	register (v: STRING_8; k: STRING_8)
		do
			variables.force (v, k)
		end

feature {NONE} -- Implementation

	template: STRING
		once
			Result := "[
				<div id="page-wrapper">
					<div id="page">
						<div id="header">
						$header
						</div>
						<div id="main-wrapper">
							<div id="main">
								<div id="first_sidebar" class="sidebar">$first_sidebar</div>
								<div id="content">$content</div>
								<div id="second_sidebar" class="sidebar">$second_sidebar</div>
							</div>
						</div>
						<div id="footer">$footer</div>
					</div>
				</div>
			]"
		end


end
