require_relative 'reactor.rb'
require_relative 'poller.rb'
require 'yaml'

CONFIG = YAML.load File.read('conf.yaml')

poller  = Poller.new(CONFIG['poller_address'])
reactor = Reactor.new("tcp://*:#{CONFIG['api_port']}", poller)

trap "INT" do
  reactor.deactivate
end

reactor.run

reactor.deactivate