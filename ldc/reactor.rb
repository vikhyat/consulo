require 'zmq'
require 'msgpack'
require_relative 'hopcount.rb'

class Reactor
  def initialize(id, poller)
    $context ||= ZMQ::Context.new(1)
    @responder = $context.socket(ZMQ::REP)
    @responder.setsockopt(ZMQ::LINGER, 0)
    @responder.bind(id)
    @poller = poller
  end

  def deactivate
    @responder.close
    @poller.deactivate
  end

  def handle_request(r)
    begin
      if r[0] == "PING"
        return "PONG"
      elsif r[0] == "HOPCOUNT"
        return hopcount(r[1])
      elsif r[0] == "TRACK"
        return @poller.track(r[1], r[2], r[3])
      elsif r[0] == "TRACKED"
        return @poller.tracked
      elsif r[0] == "FETCH"
        return @poller.fetch
      elsif r[0] == "CLEAR_TRACKS"
        return @poller.clear_tracks
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