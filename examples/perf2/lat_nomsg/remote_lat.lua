local ZMQ_NAME = "lzmq"

local argc = select("#", ...)
local argv = {...}

if (argc < 3) or (argc > 4)then
  print("usage: local_lat <bind-to> <message-size> <roundtrip-count> [ffi]")
  return 1
end

local connect_to      = argv [1]
local message_size    = assert(tonumber(argv [2]))
local roundtrip_count = assert(tonumber(argv [3]))
if argv [4] then
  assert(argv [4] == 'ffi')
  ZMQ_NAME = "lzmq.ffi"
end

local zmq      = require(ZMQ_NAME)
local ztimer   = require(ZMQ_NAME .. ".timer")
local zthreads = require(ZMQ_NAME .. ".threads")
local zassert  = zmq.assert

local ctx = zthreads.get_parent_ctx() or zassert(zmq.context())

local s = zassert(ctx:socket{zmq.REQ,
  connect = connect_to;
})

local msg = ("0"):rep(message_size)

-- local watch, us = ztimer.monotonic():start(), 1000
local watch, us = zmq.utils.stopwatch():start(), 1

for i = 1, roundtrip_count do
  zassert(s:send(msg))
  msg = zassert(s:recv())
  if #msg ~= message_size then
    printf ("message of incorrect size received\n");
    return -1;
  end
end

local elapsed = watch:stop()
local latency = (elapsed * us) / (roundtrip_count * 2)

print(string.format("message size: %d [B]",       message_size   ))
print(string.format("roundtrip count: %d",        roundtrip_count))
print(string.format("average latency: %.3f [us]", latency        ))

