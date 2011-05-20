deferred class HTTP_REQUEST_HANDLER
feature

	set_uri (new_uri: STRING)
			-- set new URI
		require
			valid_uri: new_uri /= Void
		do
			request_uri := new_uri
		end

	request_uri: STRING
			-- requested url

	set_data (new_data: STRING)
			-- set new data
		do
			data := new_data
		end

	data: STRING
			-- the entire request message


	headers : HASH_TABLE [STRING, STRING]
		-- Provides access to the request's HTTP headers, for example:
		-- headers["Content-Type"] is "text/plain"


	set_headers ( a_header : HASH_TABLE [STRING, STRING] )
		do
			headers := a_header
		end

	process
			-- process the request and create an answer
		require
			valid_uri: request_uri /= Void
		deferred
		end

	answer: HTTP_RESPONSE
			-- reply to this request

	reset
			-- reinit the fields
		do
			request_uri := Void
			data := Void
			answer := Void
		end

end
