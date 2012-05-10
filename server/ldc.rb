require 'zmq'
require 'msgpack'

class LDC
  def initialize(id)
    $context ||= ZMQ::Context.new(1)
    @requester = $context.socket(ZMQ::REQ)
    @requester.setsockopt(ZMQ::LINGER, 0)
    @requester.connect(id)
  end
  
  def timeout(timeout=2)
    yield
    # ret = false
    # Thread.new { ret = yield }.join(timeout)
    # return ret
  end

  def send(cmd, timeout=2)
    return timeout(timeout) do
      @requester.send cmd.to_msgpack
      MessagePack.unpack @requester.recv
    end
  end

  def ping(timeout=2)
    send(["PING"], timeout) == "PONG"
  end
  
  def hopcount(ip, timeout=2)
    send(["HOPCOUNT", ip], timeout)
  end
  
  def track(ne, oid, interval, timeout=2)
    send(["TRACK", ne, oid, interval], timeout)
  end
  
  def clear_tracks(timeout=2)
    send(["CLEAR_TRACKS"], timeout)
  end
  
  def tracked(timeout=2)
    send(["TRACKED"], timeout)
  end
  
  def fetch(timeout=2)
    send(["FETCH"], timeout)
  end

  def deactivate
    @requester.close
  end
end