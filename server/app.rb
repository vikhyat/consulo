require 'yaml'
require 'pp'
require_relative 'network_element.rb'
require_relative 'poll_variable.rb'

config = YAML.load File.read('config.yaml')

poll_variables = []
config["network_elements"].each do |ip, oids|
  oids.each do |oid, interval|
    poll_variables.push PollVariable.new(oid, NetworkElement.new(ip), interval)
  end
end

pp poll_variables
