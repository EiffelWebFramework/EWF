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

WGI_APPLICATION

    deferred class 
    	WGI_APPLICATION
    
    feature {NONE} -- Execution
    
    	execute (req: WGI_REQUEST; res: WGI_RESPONSE_BUFFER)
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

WGI_REQUEST

	deferred class 
		WGI_REQUEST
	feature -- Access: Input
	
		input: WGI_INPUT_STREAM
				-- Server input channel
			deferred
			end
		
	feature -- Access: extra values
	
		request_time: detachable DATE_TIME
				-- Request time (UTC)
			deferred
			end
		
	feature -- Access: CGI meta variables		
	
		meta_variable (a_name: READABLE_STRING_GENERAL): detachable READABLE_STRING_32
				-- Environment variable related to `a_name'
			require
				a_name_valid: a_name /= Void and then not a_name.is_empty
			deferred
			end
	
		meta_variables: HASH_TABLE [READABLE_STRING_32, READABLE_STRING_GENERAL]
			deferred
			end
	
	feature -- Query string Parameters
	
		query_parameters: HASH_TABLE [READABLE_STRING_32, READABLE_STRING_GENERAL]
				-- Variables extracted from QUERY_STRING
			deferred
			end
	
		query_parameter (a_name: READABLE_STRING_GENERAL): detachable READABLE_STRING_32
				-- Parameter for name `n'.
			require
				a_name_valid: a_name /= Void and then not a_name.is_empty
			deferred
			end
	
	feature -- Form fields and related
	
		form_data_parameters: HASH_TABLE [READABLE_STRING_32, READABLE_STRING_GENERAL]
				-- Variables sent by POST request
			deferred
			end
	
		form_data_parameter (a_name: READABLE_STRING_GENERAL): detachable READABLE_STRING_32
				-- Field for name `a_name'.
			require
				a_name_valid: a_name /= Void and then not a_name.is_empty
			deferred
			end
	
		uploaded_files: HASH_TABLE [WGI_UPLOADED_FILE_DATA, READABLE_STRING_GENERAL]
				-- Table of uploaded files information
				--| name: original path from the user
				--| type: content type
				--| tmp_name: path to temp file that resides on server
				--| tmp_base_name: basename of `tmp_name'
				--| error: if /= 0 , there was an error : TODO ...
				--| size: size of the file given by the http request
			deferred
			end
			
	feature -- Cookies	
	
		cookies: HASH_TABLE [READABLE_STRING_32, READABLE_STRING_GENERAL]
				-- Expanded cookies variable
			deferred
			end
	
		cookie (a_name: READABLE_STRING_GENERAL): detachable READABLE_STRING_32
				-- Field for name `a_name'.
			require
				a_name_valid: a_name /= Void and then not a_name.is_empty
			deferred
			end
	
	feature -- Access: global variable
	
		parameters: HASH_TABLE [READABLE_STRING_32, READABLE_STRING_GENERAL]
				-- Table containing all the various variables
				-- Warning: this is computed each time, if you change the content of other containers
				-- this won't update this Result's content, unless you query it again
			deferred
			end
	
		parameter (a_name: READABLE_STRING_GENERAL): detachable READABLE_STRING_32
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

WGI_RESPONSE_BUFFER

	deferred class
		WGI_RESPONSE_BUFFER
	
	feature {WGI_APPLICATION} -- Commit
	
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
	
	feature {WGI_RESPONSE_BUFFER} -- Core output operation
	
		write (s: STRING)
				-- Send the string `s'
				-- this can be used for header and body
			deferred
			end
	
	feature -- Status setting
	
		status_is_set: BOOLEAN
				-- Is status set?
			deferred
			end
	
		set_status_code (a_code: INTEGER)
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
	
		status_code: INTEGER
				-- Response status
			deferred
			end
	
	feature -- Header output operation
	
		write_headers_string (a_headers: STRING)
			require
				status_set: status_is_set
				header_not_committed: not header_committed
			deferred
			ensure
				status_set: status_is_set
				header_committed: header_committed
				message_writable: message_writable
			end
	
		write_header (a_status_code: INTEGER; a_headers: detachable ARRAY [TUPLE [key: STRING; value: STRING]])
				-- Send headers with status `a_status', and headers from `a_headers'
			require
				status_not_set: not status_is_set
				header_not_committed: not header_committed
			deferred
			ensure
				header_committed: header_committed
				status_set: status_is_set
				message_writable: message_writable
			end
	
	feature -- Output operation
	
		write_string (s: STRING)
				-- Send the string `s'
			require
				message_writable: message_writable
			deferred
			end
	
		write_substring (s: STRING; a_begin_index, a_end_index: INTEGER)
				-- Send the substring `s[a_begin_index:a_end_index]'
			require
				message_writable: message_writable
			deferred
			end
	
		write_file_content (fn: STRING)
				-- Send the content of file `fn'
			require
				message_writable: message_writable
			deferred
			end
	
		flush
				-- Flush if it makes sense
			deferred
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
