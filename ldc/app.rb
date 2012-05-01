require_relative 'reactor.rb'
require_relative 'poller.rb'
require 'yaml'

CONFIG = YAML.load File.read('config.yml')

reactor = Reactor.new("tcp://*:#{CONFIG['api_port']}")

trap "INT" do
  reactor.deactivate
end

reactor.run
