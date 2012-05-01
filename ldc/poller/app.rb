require_relative 'reactor.rb'
require 'yaml'

CONFIG = YAML.load File.read('config.yml')

reactor = Reactor.new("tcp://*:#{CONFIG['port']}")

trap "INT" do
  reactor.deactivate
end

reactor.run
