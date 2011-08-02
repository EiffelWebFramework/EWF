**WARNING** **THIS PAGE IS IN PROGRESS, AS IT IS NOW, IT NEEDS UPDATE SINCE IT DOES NOT REFLECT THE FUTURE INTERFACE**

# The Eiffel Web Server Gateway Interface
## Preface 
This specification is a proposition based on recent discussion on the mailing list.
This is work in progress, so far nothing had been decided.
You can find another proposal at http://eiffel.seibostudios.se/wiki/EWSGI , it has common background and goal, however still differ on specific parts.
The main goal for now is to unified those 2 specifications.

---
Note the following is work in progress, and reflect a specification proposal, rather than the final specification.
2011-08-01
---
For now, the specification from EWF is done in Eiffel interface
please see: https://github.com/Eiffel-World/Eiffel-Web-Framework/tree/master/library/server/ewsgi/specification

EWSGI_APPLICATION

    deferred class 
    	EWSGI_APPLICATION
    
    feature {NONE} -- Execution
    
    	execute (req: EWSGI_REQUEST; res: EWSGI_RESPONSE_BUFFER)
    			-- Execute the request
    			-- See `req.input' for input stream
    			--     `req.environment' for the Gateway environment	
    			-- and `res' for the output buffer
    		require
    			res_status_unset: not res.status_is_set
    		deferred
    		ensure
    			res_status_set: res.status_is_set
    			res_committed: res.message_committed
    		end
    	
    end

EWSGI_REQUEST

	deferred class 
		EWSGI_REQUEST
	feature -- Access: Input
	
		input: EWSGI_INPUT_STREAM
				-- Server input channel
			deferred
			end
		
	 feature -- Access: extra values
	
		request_time: detachable DATE_TIME
				-- Request time (UTC)
			deferred
			end
		
	feature -- Access: environment variables		
	
		environment: EWSGI_ENVIRONMENT
				-- Environment variables
			deferred
			end
	
		environment_variable (a_name: STRING_8): detachable STRING_8
				-- Environment variable related to `a_name'
			require
				a_name_valid: a_name /= Void and then not a_name.is_empty
			deferred
			end
		
	feature -- Access: execution variables		
	
		execution_variables: EWSGI_VARIABLES [STRING_32]
				-- Execution variables set by the application
			deferred
			end
	
		execution_variable (a_name: STRING_8): detachable STRING_32
				-- Execution variable related to `a_name'
			require
				a_name_valid: a_name /= Void and then not a_name.is_empty
			deferred
			end
		
	feature -- URL Parameters
	
		parameters: EWSGI_VARIABLES [STRING_32]
				-- Variables extracted from QUERY_STRING
			deferred
			end
	
		parameter (a_name: STRING_8): detachable STRING_32
				-- Parameter for name `n'.
			require
				a_name_valid: a_name /= Void and then not a_name.is_empty
			deferred
			end
		
	feature -- Form fields and related
	
		form_fields: EWSGI_VARIABLES [STRING_32]
				-- Variables sent by POST request
			deferred
			end
	
		form_field (a_name: STRING_8): detachable STRING_32
				-- Field for name `a_name'.
			require
				a_name_valid: a_name /= Void and then not a_name.is_empty
			deferred
			end
	
		uploaded_files: HASH_TABLE [EWSGI_UPLOADED_FILE_DATA, STRING_8]
				-- Table of uploaded files information
			deferred
			end
		
	feature -- Cookies	
	
		cookies_variables: HASH_TABLE [STRING_8, STRING_8]
				-- Expanded cookies variable
			deferred
			end
	
		cookies_variable (a_name: STRING_8): detachable STRING_8
				-- Field for name `a_name'.
			require
				a_name_valid: a_name /= Void and then not a_name.is_empty
			deferred
			end
	
		cookies: HASH_TABLE [EWSGI_COOKIE, STRING_8]
				-- Cookies Information
			deferred
			end
		
	feature -- Access: global variable
	
		variables: HASH_TABLE [STRING_32, STRING_32]
				-- Table containing all the various variables
				-- Warning: this is computed each time, if you change the content of other containers
				-- this won't update this Result's content, unless you query it again
			deferred
			end
	
		variable (a_name: STRING_8): detachable STRING_32
				-- Variable named `a_name' from any of the variables container
				-- and following a specific order
				-- execution, environment, get, post, cookies
			require
				a_name_valid: a_name /= Void and then not a_name.is_empty
			deferred
			end
		
	feature -- Uploaded File Handling
	
		is_uploaded_file (a_filename: STRING_8): BOOLEAN
				-- Is `a_filename' a file uploaded via HTTP POST
			deferred
			end
		
	feature -- URL Utility
	
		absolute_script_url (a_path: STRING_8): STRING_8
				-- Absolute Url for the script if any, extended by `a_path'
			deferred
			end
	
		script_url (a_path: STRING_8): STRING_8
				-- Url relative to script name if any, extended by `a_path'
			require
				a_path_attached: a_path /= Void
			deferred
			end
		
	end

EWSGI_RESPONSE_BUFFER

	deferred class 
		EWSGI_RESPONSE_BUFFER
	
	feature {EWSGI_APPLICATION} -- Commit
	
		commit
				-- Commit the current response
			deferred
			ensure
				status_is_set: status_is_set
				header_committed: header_committed
				message_committed: message_committed
			end
		
	feature -- Status report
	
		header_committed: BOOLEAN
				-- Header committed?
			deferred
			end
	
		message_committed: BOOLEAN
				-- Message committed?
			deferred
			end
	
		message_writable: BOOLEAN
				-- Can message be written?
			deferred
			end
		
	feature {NONE} -- Core output operation
	
		write (s: STRING_8)
				-- Send the string `s'
				-- this can be used for header and body
			deferred
			end
		
	feature -- Status setting
	
		status_is_set: BOOLEAN
				-- Is status set?
			deferred
			end
	
		set_status_code (a_code: INTEGER_32)
				-- Set response status code
				-- Should be done before sending any data back to the client
			require
				status_not_set: not status_is_set
				header_not_committed: not header_committed
			deferred
			ensure
				status_code_set: status_code = a_code
				status_set: status_is_set
			end
	
		status_code: INTEGER_32
				-- Response status
			deferred
			end
		
	feature -- Output operation
	
		flush
				-- Flush if it makes sense
			deferred
			end
	
		write_string (s: STRING_8)
				-- Send the string `s'
			require
				message_writable: message_writable
			deferred
			end
	
		write_substring (s: STRING_8; a_begin_index, a_end_index: INTEGER_32)
				-- Send the substring `s[a_begin_index:a_end_index]'
			require
				message_writable: message_writable
			deferred
			end
	
		write_file_content (fn: STRING_8)
				-- Send the content of file `fn'
			require
				message_writable: message_writable
			deferred
			end
		
	feature -- Header output operation
	
		write_header (a_status_code: INTEGER_32; a_headers: detachable ARRAY [TUPLE [key: STRING_8; value: STRING_8]])
				-- Send headers with status `a_status', and headers from `a_headers'
			require
				status_not_set: not status_is_set
				header_not_committed: not header_committed
			deferred
			ensure
				header_committed: header_committed
				status_set: status_is_set
			end
		
	end



## Proof-of-concept and reference implementation

# Specification overview

## The Server/Gateway Side

## The Application/Framework Side

## Specification Details

## Implementation/Application Notes

## Questions and Answers 

## Proposed/Under Discussion 

## Acknowledgements 

## References 