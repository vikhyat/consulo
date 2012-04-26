require 'zmq'
require 'msgpack'

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
    if r == "PING"
      return "PONG"
    else
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