# FIXME: use traceroute rather than ping.
require 'timeout'

def hopcount_noretry(ip)
  begin
    Timeout::timeout(5) do
      `ping -c 1 -R 10.6.2.254`.split("RR:")[1].split("---")[0].split("\n").length.to_f
    end
  rescue
    nil
  end
end

def hopcount(ip, retries=3)
  1.upto(retries) do
    t = hopcount_noretry(ip)
    return t if not t.nil?
  end
  return 1.0 / 0
end