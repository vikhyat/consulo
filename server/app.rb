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
      timeout(timeout) do
        return (send("PING") == "PONG")
      end
    rescue
      return false
    end
  end

  def deactivate
    @requester.close
  end
end

ldc = LDC.new("tcp://localhost:9861")
50.times { p ldc.ping }
ldc.deactivate
