note
	description: "Summary description for {WSF_BUTTON_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_BUTTON_CONTROL

inherit
	WSF_CONTROL
create
	make
feature {NONE}
	make (n:STRING; v:STRING)
	do
		make_control
		control_name:=n
		text:=v
		click_event:= agent donothing
	end
feature

	--UGLY HACK MUST BE REMOVED
	donothing(p:WSF_PAGE_CONTROL)
	do

	end
	handle_callback(event: STRING ; cname: STRING ; page: WSF_PAGE_CONTROL)
	do
		if Current.control_name = cname and attached  click_event then
			click_event.call([page])
		end
	end

	render:STRING
	do
		Result:="<button>"+text+"</button>"
	end

	state:JSON_OBJECT
	do
		create Result.make
		Result.put (create {JSON_STRING}.make_json(text), create {JSON_STRING}.make_json("text"))
	end


feature
	text: STRING
	click_event: PROCEDURE [ANY, TUPLE [WSF_PAGE_CONTROL]]
end
