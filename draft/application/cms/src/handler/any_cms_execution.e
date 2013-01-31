note
	description: "[
				This class implements the web service

				It inherits from WSF_DEFAULT_SERVICE to get default EWF connector ready
				And from WSF_URI_TEMPLATE_ROUTED_SERVICE to use the router service

				`initialize' can be redefine to provide custom options if needed.
			]"

class
	ANY_CMS_EXECUTION

inherit
	CMS_EXECUTION

create
	make,
	make_with_text

feature {NONE} -- Initialization

	make_with_text (req: WSF_REQUEST; res: WSF_RESPONSE; h: like service; t: like text)
		do
			make (req, res, h)
			text := t
		end

	text: detachable STRING

feature -- Execution

	process
			-- Computed response message.
		local
			b: STRING_8
			s: STRING
		do
			create b.make_empty
			if attached text as t then
				s := request.path_info
				if attached service.base_url as l_base_url then
					if s.starts_with (l_base_url) then
						s.remove_head (l_base_url.count)
						if s.starts_with ("/") then
							s.remove_head (1)
						end
					end
				end
				set_title (s)
				b.append (t)
			else
				set_title ("Page Not Found")
			end
			set_main_content (b)
		end

end
