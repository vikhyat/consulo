# FIXME: use traceroute rather than ping.
require 'timeout'

def hopcount(ip)
  begin
    Timeout::timeout(5) do
      `ping -c 1 -R 10.6.2.254`.split("RR:")[1].split("---")[0].split("\n").length.to_f
    end
  rescue
    1.0 / 0
  end
end