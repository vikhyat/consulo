require_relative 'ldc.rb'
require 'yaml'

CONFIG = YAML.load File.read('conf.yaml')

ldcs = []

CONFIG['ldcs'].each do |ldc_id|
  ldcs.push LDC.new("tcp://localhost:9861")
end

trap "INT" do
  ldcs.each {|ldc| ldc.deactivate }
end

def ldc_hopcounts(ldcs, element)
  hcs = {}
  ldcs.each do |ldc|
    hcs[ldc] = ldc.hopcount(element)
  end
  hcs
end

def generate_hopcounts(ldcs, network_elements)
  hopcounts = {}
  network_elements.each do |ne|
    hopcounts[ne] = ldc_hopcounts(ldcs, ne)
  end
  hopcounts
end

def best_ldc(ldcs, ne)
  min, min_ldc = 1.0 / 0, nil
  ldcs.each do |ldc|
    if ldc.hopcount(ne) < min
      min_ldc = ldc
    end
  end
  min_ldc
end

def best_ldcs(ldcs, nes)
  optimal = {}
  nes.each do |ne|
    optimal[ne] = best_ldc(ldcs, ne)
  end
  optimal
end

optimal_assignment = best_ldcs(ldcs, CONFIG['network_elements'].keys.uniq)

CONFIG['network_elements'].each do |ne, oids|
  oids.each do |oid, interval|
    if optimal_assignment[ne].nil?
      puts "#{ne} can't be tracked."
    else
      optimal_assignment[ne].track(ne, oid, interval)
    end
  end
end

ldcs.each {|ldc| p ldc.tracked }

ldcs.each {|ldc| ldc.deactivate }