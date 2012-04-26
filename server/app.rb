# coding: utf-8
require 'zmq'

context = ZMQ::Context.new(1)

# Socket to talk to server
puts "Connecting to hello world server…"
requester = context.socket(ZMQ::REQ)
requester.connect("tcp://localhost:9861")

0.upto(9) do |request_nbr|
  puts "Sending request #{request_nbr}…"
  requester.send "Hello"

  reply = requester.recv
  puts "Received reply #{request_nbr}: [#{reply}]"
end
