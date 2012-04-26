require_relative 'reactor.rb'

reactor = Reactor.new("tcp://*:9861")

trap "INT" do
  reactor.deactivate
end

reactor.run
