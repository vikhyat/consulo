require_relative 'ping.rb'
require_relative 'adaptive.rb'
require 'snmp'

class Tracked
  attr_reader :ne, :oid, :interval
  
  def initialize(ne, oid, interval)
    @ne = ne
    @oid = oid
    @interval = interval
    @adaptive = AdaptivePolling.new('double') if @interval == "adaptive"
    @active = true
    @values = []
  end
  
  def ==(other)
    (other.ne == @ne) and (other.oid == @oid) and (other.interval == @interval)
  end
  
  def deactivate
    @active = false
  end
  
  def activate
    @active = true
  end
  
  def poll
    @t_start ||= Time.now
    if @oid == "status"
      ping(@ne)
    else
      output = nil
      begin
        SNMP::Manager.open(:host => @ne) do |manager|
          response = manager.get([@oid])
          response.each_varbind do |vb|
            output = vb.value.to_s
          end
        end
      rescue
      end
      if @interval == 'adaptive'
        @adaptive.register(output)
      end
      return output
    end
  end
  
  def wait_time
    if @interval == "adaptive"
      p @adaptive.wait_time
    else
      k = 1 + (Time.now - @t_start) / @interval
      @t_start + k * @interval - Time.now
    end
  end
  
  def poll_loop
    Thread.new do
      while @active
        @values.push [poll, @oid, @ne, Time.now.to_i].reverse
        sleep wait_time
      end
    end
  end
  
  def flush
    v = @values.dup
    @values.clear
    v
  end
end