require_relative 'helper.rb'

# compute optimal ldc - network element assignment
# Thread.new do
  # loop do
    optimal_assignment = best_ldcs($ldcs, CONFIG['network_elements'].keys.uniq)

    CONFIG['network_elements'].each do |ne, oids|
      oids.each do |oid, interval|
        if optimal_assignment[ne].nil?
          puts "#{ne} can't be tracked."
        else
          optimal_assignment[ne].track(ne, oid, interval)
        end
      end
    end
    # sleep CONFIG['reassign_interval']
  # end
# end

Thread.new do  
  loop do
    $ldcs.each do |ldc|
      f = ldc.fetch
      f = [] if f == "INVALID"
      $data.save f
    end
    sleep CONFIG['fetch_interval']
  end
end
