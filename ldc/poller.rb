class Poller
  def initialize(id)
    $context ||= ZMQ::Context.new(1)
    @requester = $context.socket(ZMQ::REQ)
    @requester.setsockopt(ZMQ::LINGER, 0)
    @requester.connect(id)
  end
  
  def send(cmd, timeout=2)
    return timeout(timeout) do
      @requester.send cmd.to_msgpack
      MessagePack.unpack @requester.recv
    end
  end
  
  def track(ne, oid, interval)
    send(["TRACK", ne, oid, interval])
  end
  
  def tracked
    send(["TRACKED"])
  end
  
  def fetch
    send(["FETCH"])
  end
  
  def clear_tracks
    send(["CLEAR_TRACKS"])
  end
  
  def deactivate
    @requester.close
  end
end