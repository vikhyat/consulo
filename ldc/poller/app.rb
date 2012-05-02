require_relative 'reactor.rb'
require 'yaml'

CONFIG = YAML.load File.read('conf.yaml')

reactor = Reactor.new("tcp://*:#{CONFIG['port']}")

trap "INT" do
  reactor.deactivate
end

reactor.run
