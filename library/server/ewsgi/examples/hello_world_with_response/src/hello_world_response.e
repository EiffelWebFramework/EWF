note
    description: "A streaming (non-buffered) Hello World example."
    author: "Paul Cohen <paul.cohen@seibostudio.se>"
    status: "Draft"

class HELLO_WORLD_RESPONSE

inherit
    EWSGI_RESPONSE
        redefine
            make,
            read_block
        end

create
    make

feature {NONE} -- Initialization

  make
        do
            precursor
            set_ready_to_transmit
            current_hello := 0
        end

feature {NONE} -- Entity body

    read_block
        -- Reads a block of 100000 lines of "Hello World".
        local
            i: INTEGER
        do
            if current_hello >= 100000 then
                end_of_blocks := True
            else
                if current_hello = 0 then
                    current_block := "<html><body>%N"
                end
                from
                    i := 0
                until
                    i = 10000
                loop
                    current_block.append ("Hello World ("+ current_hello.out +","+ i.out +")<br/>%N")
                    i := i + 1
                end
                current_hello := current_hello + i
                if current_hello = 100000 then
                    current_block.append ("Bye bye..<br/></body></html>")
                end
            end
        end

    current_hello: INTEGER

;note
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
