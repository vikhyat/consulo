require 'zmq'
require 'msgpack'
require_relative 'tracked.rb'

class Reactor
  attr_reader :tracked
  
  def initialize(id)
    $context ||= ZMQ::Context.new(1)
    @responder = $context.socket(ZMQ::REP)
    @responder.setsockopt(ZMQ::LINGER, 0)
    @responder.bind(id)
    # @tracked is a ne -> oid -> interval hash
    @tracked = []
  end
  
  def deactivate
    @responder.close
  end
  
  def handle_request(r)
    begin
      if r[0] == "TRACK"
        p r
        tracked = Tracked.new(r[1], r[2], r[3])
        @tracked.push tracked if not @tracked.include? tracked
        tracked.poll_loop
        return "ADDED"
      elsif r[0] == "TRACKED"
        return @tracked.map {|x| [x.ne, x.oid, x.interval] }
      elsif r[0] == "FETCH"
        values = []
        @tracked.map {|tracked| tracked.flush }.each {|vars| values += vars }
        return values
      elsif r[0] == "CLEAR_TRACKS"
        @tracked.each {|tr| tr.deactivate }
        @tracked.clear
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