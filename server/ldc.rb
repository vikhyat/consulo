require 'zmq'
require 'msgpack'
require 'timeout'

class LDC
  def initialize(id)
    $context ||= ZMQ::Context.new(1)
    @requester = $context.socket(ZMQ::REQ)
    @requester.connect(id)
  end

  def send(cmd)
    @requester.send cmd.to_msgpack
    MessagePack.unpack @requester.recv
  end

  def ping(timeout=2)
    begin
      ret = false
      Thread.new { ret = (send("PING") == "PONG") }.join(1)
      return ret
    rescue
      return false
    end
  end

  def deactivate
    @requester.close
  end
end