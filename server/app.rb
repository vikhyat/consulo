require_relative 'ldc.rb'
require 'yaml'

CONFIG = YAML.load File.read('conf.yaml')

ldcs = []

CONFIG['ldcs'].each do |ldc_id|
  ldcs.push LDC.new("tcp://localhost:9861")
end

ldc = ldcs[0]

trap "INT" do
  ldc.deactivate
end

CONFIG['network_elements'].each do |ne, oids|
  oids.each do |oid, interval|
    ldc.track(ne, oid, interval)
  end
end

p ldc.hopcount("10.6.2.254")
ldc.deactivate