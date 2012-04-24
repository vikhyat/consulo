class PollVariable
  attr_accessor :interval
  
  def initialize(oid, network_element, interval)
    @oid = oid
    @network_element = network_element
    @interval = interval
  end
  
  def poll
    2
  end
end