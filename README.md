#Lua binding to [ZeroMQ](http://zeromq.org) library.

[![Build Status](https://travis-ci.org/moteus/lzmq.png?branch=master)](https://travis-ci.org/moteus/lzmq)

Support ZeromMQ 3.2/4.0

This library use `zmq.poller` and `zmq.threads` from [lua-zmq](https://github.com/Neopallium/lua-zmq) binding.
But this library is not dropin replacement for lua-zmq library.

----
##API
This is almost 1:1 binding to ZeromMQ 3.2 library.
This is short [API](http://moteus.github.io/lzmq/index.html) description.
See also [exampes](https://github.com/moteus/lzmq-zguide) form [OMQ - The Guide](http://zguide.zeromq.org).
###Constant
ZMQ_CONSTANT_NAME in the C API turns into zmq.CONSTANT_NAME in Lua.
###Error codes
EXXX in the C API turns into zmq.EXXX and zmq.errors.EXXX in Lua.
###Options
ZMQ_OPTION_NAME in the C API 
- if this is read/write option then it turns into 2 functions 
`obj:set_option_name(value)` and `obj:get_option_name()`

**For example:**
ZMQ_IO_THREADS => ctx:get_io_threads()/ ctx:set_io_threads(1)
- if this is readonly  option then it turns into 2 functions 
`obj:option_name()` and `obj:get_option_name()`

**For example:**
ZMQ_FD => skt:fd() / skt:get_fd()
- if this is writeonly  option then it turns into 2 functions 
`obj:option_name(value)` and `obj:set_option_name(value)`

**For example:**
ZMQ_SUBSCRIBE => skt:subscribe("") / skt:set_subscribe("")

----
##Performance
To run same test you should copy original performance tests to `exampes/perf2/libzmq`
and run `runner.lua` from `exampes/perf2`. For now it require LuaJIT and exists 
C and FFI version of `lzmq` library.
Of course you can run any test manually.

----
###Inproc Throughput Test:

message size: 1 [B]<br/>
message count: 10000<br/>
mean throughput [Mb/s]:<br/>

| # | libzmq     | str        | str(ffi)   | msg        | msg(ffi)   |
|---|------------|------------|------------|------------|------------|
| 1 |349.396     |307.141     |393.636     |186.162     |239.617     |
| 2 |350.007     |310.398     |412.371     |188.132     |248.011     |
| 3 |377.596     |311.284     |413.010     |205.076     |281.228     |
| 4 |422.535     |308.206     |414.007     |174.406     |248.679     |
| 5 |392.477     |311.324     |411.876     |181.722     |274.946     |
| 6 |382.470     |309.917     |395.127     |177.528     |631.413     |
| 7 |393.636     |324.851     |415.010     |186.437     |282.686     |
| 8 |386.910     |303.298     |379.627     |116.919     |268.908     |
| 9 |397.022     |311.931     |415.945     |187.749     |244.998     |
| 10|438.196     |302.763     |412.229     |189.813     |255.646     |

###Inproc Latency Test:

message size: 1 [B]<br/>
message count: 10000<br/>
average latency [us]:<br/>

| # | libzmq     | str        | str(ffi)   | msg        | msg(ffi)   |
|---|------------|------------|------------|------------|------------|
| 1 |97.356      |97.378      |98.221      |94.274      |96.880      |
| 2 |95.828      |96.736      |95.957      |100.711     |96.992      |
| 3 |99.656      |100.347     |95.672      |97.981      |95.312      |
| 4 |96.649      |99.943      |94.543      |96.198      |94.674      |
| 5 |96.013      |102.196     |94.184      |97.575      |94.990      |
| 6 |96.371      |97.925      |98.377      |95.350      |97.165      |
| 7 |96.253      |93.625      |97.198      |94.856      |94.544      |
| 8 |95.155      |96.371      |94.904      |96.792      |95.507      |
| 9 |94.703      |96.698      |96.924      |97.951      |95.527      |
| 10|95.635      |97.946      |95.684      |96.429      |92.629      |

----
###Incompatibility list with lua-zmq (this is not full)

|    Feature           |      lua-zmq           |        lzmq              |
|----------------------|------------------------|--------------------------|
|global zmq variable   | create                 | does not create          |
|zmq.init              | io_threads optional    | io_threads require       |
|create message        | zmq.zmq_msg_t.init_XXX | zmq.msg_init_XXX         |
|message as string     | tostring(msg)          | msg:data()/tostring(msg) |
|message as ud         | msg:data()             | msg:pointer()            |
|msg:close();msg:data()| AV                     | lua error                |

