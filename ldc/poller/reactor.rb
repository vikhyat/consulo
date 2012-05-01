require 'zmq'
require 'msgpack'

class Reactor
  def initialize(id)
    $context ||= ZMQ::Context.new(1)
    @responder = $context.socket(ZMQ::REP)
    @responder.setsockopt(ZMQ::LINGER, 0)
    @responder.bind(id)
  end
  
  def deactivate
    @responder.close
  end
  
  def handle_request(r)
    return "INVALID"
  end
  
  def run
    loop do
      request = MessagePack.unpack @responder.recv
      @responder.send(handle_request(request).to_msgpack)
    end
  end
end