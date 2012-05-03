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