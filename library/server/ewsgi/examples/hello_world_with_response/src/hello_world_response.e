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
            if current_hello >= 10000 then
                end_of_blocks := True
            else
                if current_hello = 0 then
                    current_block := "<html><style>div#status {position: absolute; top: 30%%; left: 40%%; border: red solid 1px; padding: 10px; background-color: #ffcccc;}</style><body>%N"
                    current_block.append ("<a name=%"top%">Welcome</a><br/><div id=%"status%">In progress</div>")
                end
                from
                    i := 0
                until
                    i = 1000
                loop
                    current_block.append ("Hello World ("+ current_hello.out +","+ i.out +")<br/>%N")
                    i := i + 1
                end
                current_hello := current_hello + i
				current_block.append ("<div id=%"status%">In progress - "+ (100 * current_hello // 10000).out +"%%</div>")
                if current_hello = 10000 then
                    current_block.append ("<a name=%"bottom%">Bye bye..</a><br/><div id=%"status%">Completed - GO TO <a href=%"#bottom%">BOTTOM</a></div></body></html>")
					end_of_blocks := True
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
