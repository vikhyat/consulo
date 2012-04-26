# coding: utf-8
require 'zmq'

context = ZMQ::Context.new(1)

responder = context.socket(ZMQ::REP)
responder.bind("tcp://*:9861")

loop do
  request = responder.recv
  puts "Recieved request: [#{request}]"
  sleep 1
  responder.send("world")
end
