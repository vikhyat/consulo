class Ping
  def self.pingecho(host, timeout)
    result = `ping -t #{timeout.to_i} -c 1 #{host}`
    if $?.exitstatus == 0
      return true
    else
      return false
    end
  end
end
