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
		local
			sess: NET_HTTP_CLIENT_SESSION
			h: STRING_8
			l_ctx: HTTP_CLIENT_REQUEST_CONTEXT
			l_test_case: INTEGER
			l_requestbin_path: STRING
		do
			l_requestbin_path := "/15u47xi2"
			create h.make_empty

			l_test_case := 1 -- select which test to execute

			inspect l_test_case
			when 1 then
	 			-- URL ENCODED POST REQUEST
	 			-- check requestbin to ensure the "Hello World" has been received in the raw body
	 			-- also check that User-Agent was sent
				create sess.make("http://requestb.in")
				if attached sess.post (l_requestbin_path, Void, "Hello World").headers as hds then
					across
						hds as c
					loop
						h.append (c.item.name + ": " + c.item.value + "%R%N")
					end
				end
				print (h)
			when 2 then
				-- POST REQUEST WITH FORM DATA
				-- check requestbin to ensure the form parameters are correctly received
				create sess.make("http://requestb.in")
				create l_ctx.make
				l_ctx.form_parameters.extend ("First Value", "First Key")
				l_ctx.form_parameters.extend ("Second Value", "Second Key")
				create sess.make("http://requestb.in")
				if attached sess.post (l_requestbin_path, l_ctx, "").headers as hds then
					across
						hds as c
					loop
						h.append (c.item.name + ": " + c.item.value + "%R%N")
					end
				end

			when 3 then
				-- POST REQUEST WITH A FILE
				-- check requestbin to ensure the form parameters are correctly received
				-- set filename to a local file
				create sess.make("http://requestb.in")
				create l_ctx.make
				l_ctx.set_upload_filename ("C:\temp\test.txt")
				if attached sess.post (l_requestbin_path, l_ctx, "").headers as hds then
					across
						hds as c
					loop
						h.append (c.item.name + ": " + c.item.value + "%R%N")
					end
				end

			when 4 then
				-- PUT REQUEST WITH A FILE
				-- check requestbin to ensure the file is correctly received
				-- set filename to a local file
				create sess.make("http://requestb.in")
				create l_ctx.make
				l_ctx.set_upload_filename ("C:\temp\test.txt")
				if attached sess.put (l_requestbin_path, l_ctx, "").headers as hds then
					across
						hds as c
					loop
						h.append (c.item.name + ": " + c.item.value + "%R%N")
					end
				end

			when 5 then
				-- POST REQUEST WITH A FILE AND FORM DATA
				-- check requestbin to ensure the file and form parameters are correctly received
				-- set filename to a local file
				create sess.make("http://requestb.in")
				create l_ctx.make
				l_ctx.set_upload_filename ("C:\temp\logo.png")
				l_ctx.form_parameters.extend ("First Value", "First Key")
				l_ctx.form_parameters.extend ("Second Value", "Second Key")
				if attached sess.post (l_requestbin_path, l_ctx, "").headers as hds then
					across
						hds as c
					loop
						h.append (c.item.name + ": " + c.item.value + "%R%N")
					end
				end

			when 6 then
				-- GET REQUEST, Forwarding (google's first answer is a forward)
				-- check headers received (printed in console)
				create sess.make("http://google.com")
				if attached sess.get ("/", Void).headers as hds then
					across
						hds as c
					loop
						h.append (c.item.name + ": " + c.item.value + "%R%N")
					end
				end
				print (h)

			when 7 then
				-- GET REQUEST WITH AUTHENTICATION, see http://browserspy.dk/password.php
				-- check header WWW-Authendicate is received (authentication successful)
				create sess.make("http://test:test@browserspy.dk")
				if attached sess.get ("/password-ok.php", Void).headers as hds then
					across
						hds as c
					loop
						h.append (c.item.name + ": " + c.item.value + "%R%N")
					end
				end
				print (h)
			else
		end
	end

end
