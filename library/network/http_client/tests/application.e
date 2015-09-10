note
	description : "httptest application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			requestbin_path := "/15u47xi2"
			test_1
			test_2
			test_3
			test_4
			test_5
			test_6
			test_7
		end

	requestbin_path: STRING

feature -- Tests	

	test_1
		local
			sess: NET_HTTP_CLIENT_SESSION
			h: STRING_8
			l_ctx: HTTP_CLIENT_REQUEST_CONTEXT
		do
	 			-- URL ENCODED POST REQUEST
	 			-- check requestbin to ensure the "Hello World" has been received in the raw body
	 			-- also check that User-Agent was sent
	 		create h.make_empty
			create sess.make("http://requestb.in")
			if attached sess.post (requestbin_path, Void, "Hello World").headers as hds then
				across
					hds as c
				loop
					h.append (c.item.name + ": " + c.item.value + "%R%N")
				end
			end
			print (h)
		end

	test_2
		local
			sess: NET_HTTP_CLIENT_SESSION
			h: STRING_8
			l_ctx: HTTP_CLIENT_REQUEST_CONTEXT
		do
				-- POST REQUEST WITH FORM DATA
				-- check requestbin to ensure the form parameters are correctly received
			create sess.make("http://requestb.in")
			create l_ctx.make
			l_ctx.form_parameters.extend ("First Value", "First Key")
			l_ctx.form_parameters.extend ("Second Value", "Second Key")
			create sess.make("http://requestb.in")
			create h.make_empty
			if attached sess.post (requestbin_path, l_ctx, "").headers as hds then
				across
					hds as c
				loop
					h.append (c.item.name + ": " + c.item.value + "%R%N")
				end
			end
			print (h)
		end

	test_3
		local
			sess: NET_HTTP_CLIENT_SESSION
			h: STRING_8
			l_ctx: HTTP_CLIENT_REQUEST_CONTEXT
		do
				-- POST REQUEST WITH A FILE
				-- check requestbin to ensure the form parameters are correctly received
				-- set filename to a local file
			create sess.make("http://requestb.in")
			create l_ctx.make
			l_ctx.set_upload_filename ("C:\temp\test.txt")
			create h.make_empty
			if attached sess.post (requestbin_path, l_ctx, "").headers as hds then
				across
					hds as c
				loop
					h.append (c.item.name + ": " + c.item.value + "%R%N")
				end
			end
			print (h)
		end

	test_4
		local
			sess: NET_HTTP_CLIENT_SESSION
			h: STRING_8
			l_ctx: HTTP_CLIENT_REQUEST_CONTEXT
		do
				-- PUT REQUEST WITH A FILE
				-- check requestbin to ensure the file is correctly received
				-- set filename to a local file
			create sess.make("http://requestb.in")
			create l_ctx.make
			l_ctx.set_upload_filename ("C:\temp\test.txt")
			create h.make_empty
			if attached sess.put (requestbin_path, l_ctx, "").headers as hds then
				across
					hds as c
				loop
					h.append (c.item.name + ": " + c.item.value + "%R%N")
				end
			end
			print (h)
		end

	test_5
		local
			sess: NET_HTTP_CLIENT_SESSION
			h: STRING_8
			l_ctx: HTTP_CLIENT_REQUEST_CONTEXT
		do
				-- POST REQUEST WITH A FILE AND FORM DATA
				-- check requestbin to ensure the file and form parameters are correctly received
				-- set filename to a local file
			create sess.make("http://requestb.in")
			create l_ctx.make
			l_ctx.set_upload_filename ("C:\temp\logo.png")
			l_ctx.form_parameters.extend ("First Value", "First Key")
			l_ctx.form_parameters.extend ("Second Value", "Second Key")
			create h.make_empty
			if attached sess.post (requestbin_path, l_ctx, "").headers as hds then
				across
					hds as c
				loop
					h.append (c.item.name + ": " + c.item.value + "%R%N")
				end
			end
			print (h)
		end

	test_6
		local
			sess: NET_HTTP_CLIENT_SESSION
			h: STRING_8
			l_ctx: HTTP_CLIENT_REQUEST_CONTEXT
		do
				-- GET REQUEST, Forwarding (google's first answer is a forward)
				-- check headers received (printed in console)
			create sess.make("http://google.com")
			create h.make_empty
			if attached sess.get ("/", Void).headers as hds then
				across
					hds as c
				loop
					h.append (c.item.name + ": " + c.item.value + "%R%N")
				end
			end
			print (h)
		end

	test_7
		local
			sess: NET_HTTP_CLIENT_SESSION
			h: STRING_8
			l_ctx: HTTP_CLIENT_REQUEST_CONTEXT
		do
				-- GET REQUEST WITH AUTHENTICATION, see http://browserspy.dk/password.php
				-- check header WWW-Authenticate is received (authentication successful)
			create sess.make("http://test:test@browserspy.dk")
			create h.make_empty
			if attached sess.get ("/password-ok.php", Void).headers as hds then
				across
					hds as c
				loop
					h.append (c.item.name + ": " + c.item.value + "%R%N")
				end
			end
			print (h)
		end

end
