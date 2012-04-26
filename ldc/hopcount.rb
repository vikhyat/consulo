# FIXME: use traceroute rather than ping.

def hopcount(ip)
  `ping -c 1 -R 10.6.2.254`.split("RR:")[1].split("---")[0].split("\n").length
end