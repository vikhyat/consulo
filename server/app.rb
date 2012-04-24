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


__END__
Operations to be supported:
- Poll a new OID.
- List all tracked OIDs.
- Delete an OID.
- LDCs:
  - Add an LDC
  - Remove an LDC
- Data query

Details of tracked OIDs needs to be stored somewhere persistent.
For now they will be stored in a file, but it would be wise to make this
something more robust like a Redis store or something.

