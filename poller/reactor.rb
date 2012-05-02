require 'zmq'
require 'msgpack'

class Reactor
  def initialize(id)
    $context ||= ZMQ::Context.new(1)
    @responder = $context.socket(ZMQ::REP)
    @responder.setsockopt(ZMQ::LINGER, 0)
    @responder.bind(id)
    # @tracked is a ne -> oid -> interval hash
    @tracked = {}
  end
  
  def deactivate
    @responder.close
  end
  
  def handle_request(r)
    begin
      if r[0] == "TRACK"
        @tracked[r[1]] ||= {}
        @tracked[r[1]][r[2]] = r[3]
        return "ADDED"
      elsif r[0] == "TRACKED"
        return @tracked
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
      puts "Got: #{request}"
      @responder.send(handle_request(request).to_msgpack)
    end
  end
end