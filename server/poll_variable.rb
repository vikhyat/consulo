require_relative 'ping.rb'

class PollVariable
  attr_accessor :interval
  
  def initialize(oid, network_element, interval)
    @oid = oid
    @network_element = network_element
    @interval = interval
  end
  
  def poll
    if @oid == "status"
      Ping.pingecho(@network_element.ip_address, @interval) 
    else
      nil
    end
  end
end