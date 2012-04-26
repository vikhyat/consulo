require_relative 'ldc.rb'

ldc = LDC.new("tcp://localhost:9861")

trap "INT" do
  ldc.deactivate
end

p ldc.ping
p ldc.send(["HOPCOUNT", "10.6.2.254"])
ldc.deactivate
