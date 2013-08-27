note
	description: "Summary description for {WSF_PAGE_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_PAGE_CONTROL

feature {NONE} -- Initialization

	make (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			request := req
			response := res
		end

feature -- Access

	request: WSF_REQUEST

	response: WSF_RESPONSE

feature

	initialize_controls
	deferred
	end

	process
	deferred
	end

feature


	execute
	local
		event: detachable STRING
		control_name: detachable STRING
	do
		initialize_controls
		control_name := get_parameter("control_name")
		event := get_parameter("event")
		if attached event and attached control_name and attached control then
				control.handle_callback (control_name,event, Current)
		else
			process
		render
		end
	end

	render
	local
		data: STRING
	do
		data := control.render
		response.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/plain"], ["Content-Length", data.count.out]>>)
		response.put_string (data)
	end

	get_parameter(key: STRING) : detachable STRING
	local
		value: detachable WSF_VALUE
	do
		Result := VOID
		value := request.query_parameter (key)
		if attached value then
			Result := value.as_string.value
		end

	end

feature {NONE}

	control: WSF_CONTROL

end
