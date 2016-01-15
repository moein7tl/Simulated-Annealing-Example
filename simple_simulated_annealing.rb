require './city.rb'
require './tour_manager.rb'
require './tour.rb'
require './simulated_annealing.rb'

class SimpleSimulatedAnnealing < SimulatedAnnealing

  def initialize(init_solution, temperature = 10000, cooling_rate = 0.0003)
    @start_time = Time.now.to_i
    @current_solution  = Tour.new(init_solution.tour)
    @temperature  = temperature
    @cooling_rate = cooling_rate
  end

  def run
    best  = Tour.new(@current_solution.tour)
    trails  = 0
    while(@temperature > 1)
      trails  +=  1
      new_solution = random_neighbor(@current_solution)
      current_energy  = @current_solution.get_distance
      neighbour_energy  = new_solution.get_distance

      if (SimulatedAnnealing.acceptance_probability(current_energy, neighbour_energy, @temperature) > rand)
        @current_solution = Tour.new(new_solution.tour)
        best  = Tour.new(@current_solution.tour) if (@current_solution.get_distance < best.get_distance)
      end

      @temperature *=  1 - @cooling_rate
    end

    puts 'Leaner:'
    puts "  Distance  : #{best.get_distance}"
    puts "  Time  : #{Time.now.to_i - @start_time} secs"
    puts "  Trails  : #{trails}"
  end

end