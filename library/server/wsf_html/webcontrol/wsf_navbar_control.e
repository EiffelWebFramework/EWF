note
	description: "Summary description for {WSF_NAVBAR_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_NAVBAR_CONTROL

inherit

	WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]

create
	make_navbar

feature

			collapse: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]
			nav: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]



feature {NONE} -- Initialization

	make_navbar(brand:STRING)
		local
			container: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]
			header: WSF_STATELESS_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		do
			make_multi_control
			add_class ("navbar navbar-inverse navbar-fixed-top")
			create header.make_multi_control
			create nav.make_multi_control
			create collapse.make_multi_control
			add_control (header)
			header.add_class ("navbar-header")
				--			<div class="navbar navbar-inverse navbar-fixed-top">
				--            <div class="container">
				--                <div class="navbar-header">
				--                    <button class="navbar-toggle" data-target=".navbar-collapse" data-toggle="collapse" type="button">
				--                        <span class="icon-bar"></span>
				--                    </button>
				--                    <a class="navbar-brand" href="#">WG Manager
				--                    </a>
				--                </div>
				--                <div class="navbar-collapse in" style="height: auto;">
				--                    <ul class="nav navbar-nav">
				--                        <li class="active">
				--                            <a href="/wgmanager">
				--                                <span class="glyphicon glyphicon-home"></span> Home
				--                            </a>
				--                        </li>
				--                        <li>
				--                            <a href="users">Users
				--                            </a>
				--                        </li>
				--                        <li>
				--                            <a href="about">About
				--                            </a>
				--                        </li>
				--                    </ul>
				--                    <ul class="nav navbar-nav navbar-right" id="loginnavbar">
				--                        <li>
				--                            <a href="register">
				--                                <span class="glyphicon glyphicon-pencil"></span> Register
				--                            </a>
				--                        </li>
				--                        <li class="dropdown">
				--                            <a class="dropdown-toggle" data-toggle="dropdown" href="#">
				--                                <span class="glyphicon glyphicon-log-in"></span> Sign In
				--                                <strong class="caret"></strong>
				--                            </a>
				--                            <ul class="dropdown-menu" style="min-width: 250px; padding: 15px; padding-bottom: 0px">
				--                                <form id="signinform" onsubmit="check_login();return false;">
				--                                    <div class="alert alert-danger" id="login_alert" style="display: none"></div>
				--                                    <div class="form-group">
				--                                        <input class="form-control" id="username" autofocus="autofocus" placeholder="username" name="username" type="text">
				--                                    </div>
				--                                    <div class="form-group">
				--                                        <input class="form-control" id="password" placeholder="password" name="password" type="password">
				--                                    </div>
				--                                    <div class="checkbox">
				--                                        <label>
				--                                            <input type="checkbox"> Remember me
				--                                        </label>
				--                                    </div>
				--                                    <div class="form-group">
				--                                        <input class="btn btn-primary btn-block form-control" id="signin" value="Sign In" type="submit">
				--                                    </div>
				--                                </form>
				--                            </ul>
				--                        </li>
				--                    </ul>
				--                    <ul class="nav navbar-nav navbar-right" id="accountnavbar" style="display: none">
				--                        <li>
				--                            <a id="account" href="account">
				--                                <span class="glyphicon glyphicon-user"></span>
				--                            </a>
				--                        </li>
				--                        <li>
				--                            <a href="javascript:logout()">
				--                                <span class="glyphicon glyphicon-log-out"></span> Logout
				--                            </a>
				--                        </li>
				--                    </ul>
				--                </div>
				--            </div>
				--        </div>
		end

end
