note
	description: "Summary description for {WSF_FILE_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_FILE_CONTROL

inherit

	WSF_VALUE_CONTROL [detachable WSF_FILE]
		rename
			make as make_value_control
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_value_control ("input")
		end

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	set_state (new_state: JSON_OBJECT)
			-- Restore text from json
		do
			if attached {JSON_STRING} new_state.item ("file") as new_name and attached {JSON_STRING} new_state.item ("type") as new_type and attached {JSON_NUMBER} new_state.item ("size") as new_size then
				create file.make (new_name.unescaped_string_32, new_type.unescaped_string_32, new_size.item.to_integer_32, VOID);
			end
		end

	state: WSF_JSON_OBJECT
			-- Return state which contains the current text and if there is an event handle attached
		do
			create Result.make
			Result.put_boolean (attached change_event, "callback_change")
			if attached file as f then
				Result.put_string (f.name, "file_name")
				Result.put_string (f.type, "file_type")
				Result.put_integer (f.size, "file_size")
				Result.put_string (f.id, "file_id")
			end
		end

feature -- Event handling

	set_change_event (e: attached like change_event)
			-- Set text change event handle
		do
			change_event := e
		end

	set_upload_function (e: attached like upload_function)
			-- Set button click event handle
		do
			upload_function := e
		end

	handle_callback (cname: LIST [STRING]; event: STRING; event_parameter: detachable ANY)
		local
			a_file: WSF_FILE
		do
			if Current.control_name.same_string (cname [1]) then
				if attached change_event as cevent and event.same_string ("change") then
					cevent.call (Void)
				elseif attached upload_function as ufunction and event.same_string ("uploadfile") and attached {ITERABLE [WSF_UPLOADED_FILE]} event_parameter as files then
					if attached file as f then
						a_file := f
					else
						create a_file.make ("", "", 0, VOID)
					end
					a_file.set_id (ufunction.item ([files]))
				end
			end
		end

feature -- Upload

	start_upload
		local
			upload: WSF_JSON_OBJECT
		do
			create upload.make
			upload.put_string ("start_upload", "type")
			actions.add (upload)
		end

feature -- Implementation

	value: detachable WSF_FILE
		do
			Result := file
		end

	render: STRING
		do
			Result := render_tag ("", "type=%"file%"  ")
		end

feature -- Properties

	file: detachable WSF_FILE
			-- Text to be displayed

	change_event: detachable PROCEDURE [ANY, TUPLE]
			-- Procedure to be execued on change

	upload_function: detachable FUNCTION [ANY, TUPLE [ITERABLE [WSF_UPLOADED_FILE]], detachable STRING]
			-- Store uploaded file and return server side file id

end
