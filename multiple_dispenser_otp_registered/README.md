dispenser
=====

An OTP application

Build
-----

    $ rebar3 compile


#Differences
The difference between this implementation and (multiple_dispenser_otp)[https://github.com/minostro/ticket-dispenser/tree/master/multiple_dispenser_otp] are the followings:

* ```dispenser_worker_sup``` is a registered process using the dispenser_worker_sup name, which make easy to send message to it.
* ```dispenser_worker_sup``` is started by ```dispenser_sup``` instead of being started during initialization for ```dispenser_front_desk```.
* En general this approach is easier to work with because ```dispenser_front_desk``` doesn't need to store the ```dispenser_worker_sup``` pid.
* The multiple_dispenser_otp is more flexible than this approach because ```dispenser_front_desk``` can spawn multiple supervisors and dynamically decide to whom supervisor attach a new dispenser_worker.
