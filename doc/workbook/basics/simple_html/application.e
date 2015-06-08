note
	description : "Basic Service that Generate HTML"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	WSF_DEFAULT_SERVICE
		redefine
			initialize
		end

create
	make_and_launch

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			set_service_option ("port", 9090)
		end

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the incomming request
		do
				-- To send a response we need to setup, the status code and
				-- the response headers.
			res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", web_page.count.out]>>)
			res.put_string (web_page)
		end


	web_page: STRING = "[
	<!DOCTYPE html>
	<html>
		<head>
			<title>Resume</title>
		</head>
		<body>
			<div id="header">
				<p id="name">Your Name Here</p>
				<a href="mailto:you@yourdomain.com"><p id="email">you@yourdomain.com</p></a>
			</div>
			<div class="left"></div>
			<div class="right">
				<h4>Objective</h4>
				<p>To take a position as a software engineer.</p>
				<h4>Experience</h4>
				<p>Junior Developer, Software Company (2010 - Present)</p>
				<ul>
					<li>Designed and implemented end-user features for Flagship Product</li>
					<li>Wrote third-party JavaScript and Eiffel libraries</li>
				</ul>
				<h4>Skills</h4>
				<p>Languages: C#, JavaScript, Python, Ruby, Eiffel</p>
				<p>Frameworks: .NET, Node.js, Django, Ruby on Rails, EWF</p>
				<h4>Education</h4>
				<p>BS, Economics, My University</p>
				<ul>
					<li>Award for best senior thesis</li>
					<li>GPA: 3.8</li>
				</ul>
			</div>
			<div id="footer">
				<p>123 Your Street, Anytown, State 12345-6789 | Tel: (555) 555-5555</p>
			</div>
		</body>
	</html>
]"


end
