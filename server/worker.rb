require_relative 'helper.rb'
require 'thread'

def reassign
  optimal_assignment = best_ldcs($ldcs, CONFIG['network_elements'].keys.uniq)
  $ldcs.each {|ldc| ldc.clear_tracks }
  
  CONFIG['network_elements'].each do |ne, oids|
    oids.each do |oid, interval|
      if optimal_assignment[ne].nil?
        puts "#{ne} can't be tracked."
      else
        optimal_assignment[ne].track(ne, oid, interval)
      end
    end
  end
end

def fetch
  $ldcs.each do |ldc|
    f = ldc.fetch
    f = [] if f == "INVALID"
    $data.save f
  end
end

$queue = Queue.new

# reassigning
Thread.new do
  loop do
    $queue.push 'reassign'
    sleep CONFIG['reassign_interval']
  end
end

# fetching
Thread.new do
  loop do
    $queue.push 'fetch'
    sleep CONFIG['fetch_interval']
  end
end

# worker
Thread.new do
  loop do
    task = $queue.pop
    if task == 'fetch'
      fetch
    elsif task == 'reassign'
      reassign
    end
  end
end