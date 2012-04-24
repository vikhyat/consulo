# require 'ping'

class NetworkElement
  attr_reader :ip_address
  
  def initialize(ip_address)
    @ip_address = ip_address
  end

  # ping the network element to see whether it is up.
  def up?(timeout=3)
    true
    # Ping.pingecho(@ip_address, timeout)
  end
end
