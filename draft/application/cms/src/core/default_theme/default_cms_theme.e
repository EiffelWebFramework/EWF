note
	description: "Summary description for {CMS_THEME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEFAULT_CMS_THEME

inherit
	CMS_THEME

create
	make

feature {NONE} -- Initialization

	make (a_service: like service)
		do
			service := a_service
		end

	service: CMS_SERVICE

feature -- Access

	name: STRING = "CMS"

	regions: ARRAY [STRING]
		once
			Result := <<"header", "content", "footer", "first_sidebar", "second_sidebar">>
		end

	html_template: DEFAULT_CMS_HTML_TEMPLATE
		local
			tpl: like internal_html_template
		do
			tpl := internal_html_template
			if tpl = Void then
				create tpl.make (Current)
				internal_html_template := tpl
			end
			Result := tpl
		end

	page_template: DEFAULT_CMS_PAGE_TEMPLATE
		local
			tpl: like internal_page_template
		do
			tpl := internal_page_template
			if tpl = Void then
				create tpl.make (Current)
				internal_page_template := tpl
			end
			Result := tpl
		end

	css: STRING
		do
			Result := "[
					body { margin: 0; }
					div#header { background-color: #00a; color: #fff; border: solid 1px #00a; padding: 10px;}
					div#header img#logo { float: left; margin: 3px; }
					div#header div#title {font-size: 180%; font-weight: bold; }
					ul.horizontal {
						list-style-type: none;
					}
					ul.horizontal li {
						display: inline;
						padding: 5px;
					}
					div#first-menu { padding: 5px; color: #ccf; background-color: #006; }
					div#first-menu a { color: #ccf; }
					div#second-menu { color: #99f;  background-color: #333; }
					div#second-menu a { color: #99f; }					
					
					div#left_sidebar {
						width: 150px;
						border: solid 1px #009;
						margin: 5px; 
						padding: 5px;
						width: 150px;
						display: inline;
						float: left;
						position: relative;
					}
					div#main-wrapper {
						clear: both;
						display: block;
						height: 0;
					}
					div#main { margin: 0; padding: 10px; clear: both; height:0; display: block; }
					div#content { padding: 10px; border: solid 1px #00f; 
						width: 700px;
						display: inline;
						float: left;
						position: relative;
					}
					div#footer { margin: 10px 0 10px 0; clear: both; display: block; text-align: center; padding: 10px; border-top: solid 1px #00f; color: #fff; background-color: #333;}
					div#footer a { color: #ff0; }
				]"
		end

feature -- Conversion

	prepare (page: CMS_HTML_PAGE)
		do
			if attached css as t_css then
--				page.head_lines.extend ("<style  type=%"text/css%">%N" + t_css + "%N</style>")
				page.add_style (url ("/theme/style.css", Void), Void)
			end
		end

	page_html (page: CMS_HTML_PAGE): STRING_8
		local
			l_content: STRING_8
		do
			prepare (page)
			page_template.prepare (page)
			l_content := page_template.to_html (page)
			html_template.prepare (page)
			html_template.register (l_content, "page")
			Result := html_template.to_html (page)
		end

feature {NONE} -- Internal

	internal_page_template: detachable like page_template

	internal_html_template: detachable like html_template

invariant
	attached internal_page_template as inv_p implies inv_p.theme = Current
end
