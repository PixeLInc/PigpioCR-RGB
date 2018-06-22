# PigpioCR RGB Edition
Note: While this is a minimal library for Pigpio, its main use is for controlling RGB led strips and will not support features that do not relate to that.

Control your led light strips using pigpio and the gpio connectors on a
raspberry pi.

### What do I need? ###
You'll need crystal installed, there's a few tutorials on how to install crystal
on a raspberry pi. Then you need to install pigpiod, the best way I found was to
use ubuntu or raspian and just a simple `apt install pigpiod` and then you start
the daemon using `sudo pigpiod` and you can party away.

This library connects to the locally running pigpio daemon on your raspberry pi,
but it can also be used to connect to remote instances of pigpio by passing in a
different host and port which allows you to control _all the things :tm:_

# Okay, I've got  everything installed and the daemon running, now what?
Once you've installed crystal, and started the daemon you can do a few things. The primary usage of this is to provide an interface to pigpio via crystal and allow me to remotely control the daemon from a phone, another pc/website, etc..\n

This can be done by just straight out running `crystal src/run.cr` which will start the IPC server on port 4456 (configurable).
Otherwise, you can just require the library and execute commands yourself to do what you wish without starting up the IPC server.
