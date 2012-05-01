class Poller
  def initialize(id)
    $context ||= ZMQ::Context.new(1)
    @requester = $context.socket(ZMQ::REQ)
    @requester.setsockopt(ZMQ::LINGER, 0)
    @requester.connect(id)
  end
end