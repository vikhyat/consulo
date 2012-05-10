require_relative 'reactor.rb'
require 'yaml'

CONFIG = YAML.load File.read('conf.yaml')

reactor = Reactor.new(CONFIG['poller_address'])

trap "INT" do
  reactor.deactivate
end

reactor.run
