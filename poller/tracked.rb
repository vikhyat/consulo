require_relative 'ping.rb'
require 'snmp'

class Tracked
  attr_reader :ne, :oid, :interval
  
  def initialize(ne, oid, interval)
    @ne = ne
    @oid = oid
    @interval = interval
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
      SNMP::Manager.open(:host => host) do |manager|
        response = manager.get([@oid])
        response.each_varbind do |vb|
          output = vb.value.to_s
        end
      end
      return rand
    end
  end
  
  def next_poll_time
    k = 1 + (Time.now - @t_start) / @interval
    @t_start + k * @interval
  end
  
  def poll_loop
    Thread.new do
      while @active
        @values.push [poll, @oid, @ne, Time.now.to_i].reverse
        sleep (next_poll_time - Time.now)
      end
    end
  end
  
  def flush
    v = @values.dup
    @values.clear
    v
  end
end