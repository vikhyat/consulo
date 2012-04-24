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

data = {}
threads = []

poll_variables.each do |pv|
  data[pv] = {}
  threads.push Thread.new {
    5.times do
      data[pv][Time.now.to_i] = pv.poll
      sleep pv.interval
    end
  }
end

threads.each {|t| t.join }

pp data