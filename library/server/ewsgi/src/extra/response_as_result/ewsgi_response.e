note
    description: "[
        An EWSGI response. This may be used as is or specialized (subclassed) 
        if a developer wishes to reimplement their own version of the feature
        'read_message_body_block' for supporting a block-based message body
        response.
        ]"
    author: "Paul Cohen <paul.cohen@seibostudio.se>"
    status: "Draft"

class EWSGI_RESPONSE

create
    make

feature {NONE} -- Initialization

    make
            -- Create new response object
        do
            is_buffered := False
            ready_to_transmit := False
            end_of_blocks := False
            max_block_size := default_max_block_size
            current_block := ""
            create headers_table.make (10)
        end

feature {EWSGI_RESPONSE_APPLICATION} -- Response status

	transmit_to (res: EWSGI_RESPONSE_BUFFER)
		do
                res.set_status_code (status)
                res.write_headers_string (headers)
                from
                    read_block
                    res.write_string (last_block)
--                    res.flush
                until
                    end_of_blocks
                loop
                    read_block
                    res.write_string (last_block)
--                    res.flush
                end
		end

    ready_to_transmit: BOOLEAN
        -- Is this response ready to be transmitted?

    set_ready_to_transmit
            -- Set response to ready to transmit.
        do
            if is_buffered then
                set_header ("Content-Length", current_block.count.out)
--            elseif tmp_file /= Void then
--                if tmp_file.is_open_write then
--                    tmp_file.close
--                    set_header ("Content-Length", tmp_file.count.out)
--                end
            end
            ready_to_transmit := True
        ensure
            ready_to_transmit
        end

feature {EWSGI_RESPONSE_APPLICATION} -- Message start line and status

    status: INTEGER
            -- HTTP status code

    set_status (s: INTEGER)
            -- Set 'status_code'.
        do
            status := s
            set_header ("Status", s.out)
        ensure
            status = s
        end

    start_line: STRING
            -- HTTP message start-line
        do
        	if attached status as st then
				Result := "HTTP/1.1 " + st.out + " " + status_text (st) + crlf
			else
				Result := "HTTP/1.1 200 " + status_text (200) + crlf
        	end
		end

feature {EWSGI_RESPONSE_APPLICATION} -- Message headers

    headers: STRING
             -- HTTP message headers including trailing empty line.
        local
            t: HASH_TABLE [STRING, STRING]
        do
            Result := ""
            t := headers_table
            from
                t.start
            until
                t.after
            loop
                Result.append (t.key_for_iteration + ": " + t.item_for_iteration + crlf)
                t.forth
            end
            Result.append (crlf)
        end

    headers_table: HASH_TABLE [STRING, STRING]
            -- Hash table of HTTP headers

    set_header (key, value: STRING)
            -- Set the HTTP header with the given 'key' to the given 'value'.
        do
            headers_table.put (value, key)
        ensure
            headers_table.has (key) and headers_table @ key = value
        end

feature {EWSGI_RESPONSE_APPLICATION} -- Message body

    read_block
            -- Read a message body block.
        do
            if is_buffered then
                end_of_blocks := True
--            else
--                -- File based block-based output
--                -- TBD!
            end
        ensure
            not is_buffered implies last_block.count <= max_block_size
        end

    last_block: STRING
            -- Last message body block that has been read.
        do
            Result := current_block
        end

    is_buffered: BOOLEAN
            -- Is the entire entity body buffered in memory (STRING)?

    end_of_blocks: BOOLEAN
            -- Has the last of the entity body blocks been read?

    set_message_body (s: STRING)
            -- Set the message body to 's'. Use this for when you want a memory
            -- buffered response.
        do
            current_block := s
            is_buffered := True
            set_ready_to_transmit
        ensure
            is_buffered
            ready_to_transmit
            last_block.is_equal (s)
        end

    max_block_size: INTEGER
            -- Maximum block size returned by message body if not buffered

    set_max_block_size (block_size: INTEGER)
            -- Set 'max_block_size'.
        do
            max_block_size := block_size
        ensure
            max_block_size = block_size
        end

--    write_message_block (s: STRING)
--            -- Write message body block 's' to a temporary file. Us this when
--            -- you want a non-buffered response.
--        require
--            not is_buffered
--        do
--            -- TBD!
--        ensure
--            not is_buffered
--            not ready_to_transmit
--        end

feature {NONE} -- Implementation

--    tmp_file_name: STRING

--    tmp_file: detachable FILE
--            -- Created with mktmp

--    position: INTEGER
--            -- Current read position in tmp_file

    current_block: STRING
            -- Current message body block

    default_max_block_size: INTEGER = 65536
            -- Default value of 'max_block_size'

    crlf: STRING = "%/13/%/10/"

    status_text (code: INTEGER): STRING
        do
            inspect code
            when 500 then
                Result := "Internal Server Error"
            when 200 then
                Result := "OK"
            else
               	Result := "Code " + code.out
            end
        end

note
	copyright: "2011-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
