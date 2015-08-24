Date: 2015-june

# Goal:
=======
- support safe concurrency with EWF
- provide a concurrent standalone connector

# Status: 
=========
- The version v0 of EWF has mainly 3 connectors: CGI, libFCGI, and nino. 
  - CGI and libFCGI connectors does not need any concurrency support.
  - But the nino connector had a pseudo concurrency support with Thread, however one could do write code that result in hasardeous concurrency execution. 

So, it was decided to provide an improved Eiffel web nino connector, and update EWF design to make it concurrency compliant.

# Decisions:
============
- instead of updating current nino library, we now have a new "standalone" connector which is inspired by nino, but have support for the 3 concurrency modes: none, thread and SCOOP.


# Overview
==========
Adding support for SCOOP concurrency mode add constraints to the design, but also helps ensuring the concurrency design of EWF is correct.

As a consequence, we had to introduce a new interface WSF_EXECUTION which is instantiated for each incoming request. See its simplified interface :
<code lang="eiffel">
	deferred class WSF_EXECUTION

	feature -- Initialization

		make (req: WGI_REQUEST; res: WGI_RESPONSE)
			do
				...
				īnitialize
			end

		initialize
				-- Initialize Current object.
				--| To be redefined if needed.
			do
			end
		

	feature -- Access

		request: WSF_REQUEST
				-- Access to request data.
				-- Header, Query, Post, Input data..

		response: WSF_RESPONSE
				-- Access to output stream, back to the client.

	feature -- Execution

		execute
				-- Execute Current `request',
				-- getting data from `request'
				-- and response to client via `response'.
			deferred
			ensure
				is_valid_end_of_execution: is_valid_end_of_execution
			end

	end
</code>

And the related request execution routines are extracted from WSF_SERVICE which becomes almost useless. The "service" part is not mostly responsible of launching the expected connector and set optional options, and declare the type of "execution" interface.

As a result, the well known WSF_DEFAULT_SERVICE has now a formal generic that should conform to WSF_EXECUTION with a `make' creation procedure. See update code:

<code lang="eiffel">
	class
		APPLICATION

	inherit
		WSF_DEFAULT_SERVICE [APPLICATION_EXECUTION]
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

	end
</code>

Where APPLICATION_EXECUTION is an implementation of the WSF_EXECUTION interface (with the `make' creation procedure).

In addition to add better and safer concurrency support, there are other advantages:
- we now have a clear separation between the service launcher, and the request execution itself.
- the WSF_EXECUTION is created per request, with two main attributes <code>request: WSF_REQUEST</code> and <code>response: WSF_RESPONSE</code>.

# How to migrate to new design
- you can check the various example from the EWF repository, there should all be migrated to new design and comparing previous and new code, this will show you how the migration was done.
- a frequent process:
   - identify the root class of your service, (the class implementing the WSF_SERVICE), let us name it APPLICATION_SERVICE
   - copy the APPLICATION_SERVICE file to APPLICATION_EXECUTION file.
   - change the class name to be APPLICATION_EXECUTION, and replace _SERVICE occurences by _EXECUTION (note the new WSF_ROUTED_EXECUTION and so on, which are mainly migration from previous WSF_ROUTED_SERVICE .., and also  WSF_FILTERED_ROUTED_EXECUTION which is new.
   - replace "make_and_launch" by "make", remove the initialize redefinition if any.
   - in the APPLICATION_SERVICE class, remove most of the ROUTED, FILTERED ... inheritance, and keep WSF_DEFAULT_SERVICE, with a new formal generic i.e WSF_DEFAULT_SERVICE [APPLICATION_EXECUTION].
      - in the eventual redefined initialize, remove code related to routers, filters, ...
	  - remove all the execution related code.
   - And you should be done.
   - To be short, this is mostly creating a new _EXECUTION class, and move the execution related code into this class from the _SERVICE class.
- Then, you can replace the usage of nino connector by using the new "Standalone" connector, and switch to SCOOP concurrency mode, to ensure you are not messing up with concurrency. Your own code/libraris may not be SCOOP compliant, we recommend to migrate to SCOOP, but as an intermediate solutioņ, you can use the other concurrency mode (none or thread).

Note: the new design impacts the _SERVICE classes, connectors, but WSF_REQUEST, WSF_RESPONSE , WSF_ROUTER are compatible, so the migration is really easy.

We may take the opportunity to update the design deeper according to user feedback, and eventually "wsf" library will be renamed "wsf2".
This is work in progress, all comments , feedback, suggestions, bug report are welcome. 
Hopefully before the final version of the new design is out.


