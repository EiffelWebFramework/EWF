note
	description: "Object describing a log entry"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEB_DRIVER_LOG
feature

	timestamp : NATURAL_32
		--The timestamp of the entry.

	level : detachable STRING_32
		--The log level of the entry, for example, "INFO" (see log levels).	
		--ALL	 All log messages. Used for fetching of logs and configuration of logging.
		--DEBUG	 Messages for debugging.
		--INFO	 Messages with user information.
		--WARNING	 Messages corresponding to non-critical problems.
		--SEVERE	 Messages corresponding to critical errors.
		--OFF	 No log messages. Used for configuration of logging.

	message : detachable STRING_32
		--The log message.

end
