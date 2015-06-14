ticket-dispenser
================

Toy Erlang Project


1. Create a Ticket Dispenser by using an Erlang Process
2. Create a Ticket Dispenser that uses OTP Framework
	1. install rebar3
	2. rebar3 new app dispenser


	      |SUP|

 Coordinator	 w1
       --monitor-->

 1- Coordinator ! {create_worker}
 2- ChildPid = Cordinator calls supervisor:add_child
 3- erlang:monitor(ChildPid)