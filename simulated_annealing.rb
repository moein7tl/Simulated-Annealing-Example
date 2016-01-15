class SimulatedAnnealing

  def self.acceptance_probability(energy, new_energy, temperature)
    return 1.0 if new_energy < energy
    Math.exp((energy - new_energy) / temperature)
  end


  def random_neighbor(tour)
    new_solution = Tour.new(tour.tour)
    tour_pos1  = rand(new_solution.tour_size)
    tour_pos2  = rand(new_solution.tour_size)
    city_swap1 = new_solution.tour[tour_pos1]
    city_swap2 = new_solution.tour[tour_pos2]
    new_solution.set_city(tour_pos2, city_swap1)
    new_solution.set_city(tour_pos1, city_swap2)
    return new_solution
  end

  def metropolis(temperature, max_accepted, max_generated)
    accepted = generated = 0
    costs_list = Array.new
    loop do
      generated +=  1
      new_solution  = random_neighbor(@current_solution)
      current_energy  = @current_solution.get_distance
      neighbour_energy  = new_solution.get_distance
      costs_list.push(neighbour_energy)
      if (SimulatedAnnealing.acceptance_probability(current_energy, neighbour_energy, temperature) > rand)
        accepted += 1
        @current_solution = new_solution
        @best  = Tour.new(@current_solution.tour) if (@current_solution.get_distance < @best.get_distance)
      end
      break if (accepted >= max_accepted or generated >= max_generated)
    end
    return costs_list
  end

  def self.standard_deviation(costs_list)
    average = costs_list.inject{|sum,x| sum + x } / costs_list.size
    sum  = 0
    costs_list.each do |cost|
      sum  +=  (cost - average)**2
    end
    return Math.sqrt(sum / costs_list.size)
  end

  def self.equilibrium_deviation(costs_list, temperature)
    exp_sum = 0
    costs_list.each do |cost|
      exp_sum +=  Math.exp( -cost / temperature)
    end

    variance = 0
    costs_list.each do |cost|
      variance +=  ((cost**2 - cost) * Math.exp(-cost / temperature)) / exp_sum
    end

    return Math.sqrt(variance)
  end


end