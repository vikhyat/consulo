require 'ping'

class NetworkElement
  def initialize(ip_address)
    @ip_address = ip_address
  end

  # ping the network element to see whether it is up.
  def up?(timeout=3)
    Ping.pingecho(@ip_address, timeout)
  end
end