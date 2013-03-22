note
	description: "Summary description for {WGI_DELAYED_HEADER_RESPONSE}."
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_WGI_DELAYED_HEADER_RESPONSE

inherit
	WGI_FILTER_RESPONSE
		redefine
			commit,
			put_character,
			put_string,
			put_substring,
			flush,
			message_writable,
			message_committed
		end

	WSF_RESPONSE_EXPORTER

create
	make

feature {NONE} -- Initialization

	make (r: WGI_RESPONSE; res: WSF_RESPONSE)
		do
			wsf_response := res
			make_with_response (r)
		end

feature {NONE} -- Implementation		

	wsf_response: WSF_RESPONSE

	commit
		do
			if not header_committed then
				process_header
			end
			Precursor
		end

	process_header
		require
			header_not_committed: not header_committed
		do
				-- If no content is sent, the final `{WGI_REPONSE}.push' will call `process_header'
				-- via `{WGI_RESPONSE}.post_commit_action'
			wgi_response.set_post_commit_action (Void)

				-- commit status code and reason phrase
				-- commit header text
			wsf_response.process_header

				-- update wgi_response on wsf_response to send content directly
			wsf_response.set_wgi_response (wgi_response)
		ensure
			header_committed: header_committed
		end

feature -- Status report	

	message_writable: BOOLEAN = True
			-- Can message be written?

	message_committed: BOOLEAN
			-- <Precursor>
		do
			Result := header_committed
		end

feature -- Output operation

	put_character (c: CHARACTER_8)
			-- Send the character `c'
		do
			process_header
			Precursor (c)
		end

	put_string (s: READABLE_STRING_8)
			-- Send the string `s'
		do
			process_header
			Precursor (s)
		end

	put_substring (s: READABLE_STRING_8; a_begin_index, a_end_index: INTEGER)
			-- Send the substring `s[a_begin_index:a_end_index]'
		do
			process_header
			Precursor (s, a_begin_index, a_end_index)
		end

	flush
			-- Flush if it makes sense
		do
			process_header
			Precursor
		end

note
	copyright: "2011-2013, Jocelyn Fiat, Javier Velilla, Olivier Ligot, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
