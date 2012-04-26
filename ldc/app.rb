# coding: utf-8
require 'zmq'
require 'msgpack'

context = ZMQ::Context.new(1)

responder = context.socket(ZMQ::REP)
responder.bind("tcp://*:9861")

loop do
  request = MessagePack.unpack responder.recv
  puts "Recieved request: [#{request.inspect}]"
  sleep 1
  responder.send("PONG".to_msgpack)
end
