require 'zmq'
require 'msgpack'
require_relative 'hopcount.rb'

class Reactor
  def initialize(id)
    $context ||= ZMQ::Context.new(1)
    @responder = $context.socket(ZMQ::REP)
    @responder.bind(id)
  end

  def deactivate
    @responder.close
  end

  def handle_request(r)
    begin
      if r[0] == "PING"
        return "PONG"
      elsif r[0] == "HOPCOUNT"
        return hopcount(r[1])
      else
        return "INVALID"
      end
    rescue
      return "INVALID"
    end
  end

  def run
    loop do
      request = MessagePack.unpack @responder.recv
      @responder.send(handle_request(request).to_msgpack)
    end
  end
end