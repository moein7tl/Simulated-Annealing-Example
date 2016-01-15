require './city.rb'
require './tour_manager.rb'
require './tour.rb'
require './simulated_annealing.rb'

class HuangSimulatedAnnealing < SimulatedAnnealing

  def initialize(init_solution,temperature = 10000, max_accepted = 50, max_generated = 500)
    @start_time = Time.now.to_i
    @current_solution = Tour.new(init_solution.tour)
    @temperature  = temperature
    @max_accepted = max_accepted
    @max_generated  = max_generated
    @best  = Tour.new(@current_solution.tour)
  end

  def run
    trails = 0
    while(@temperature > 1)
      trails  += 1
      costs_list  = metropolis(@temperature, @max_accepted, @max_generated)
      deviation = SimulatedAnnealing.equilibrium_deviation(costs_list, @temperature)
      @temperature  = @temperature * Math.exp( (-0.7 * @temperature) / deviation)
    end

    puts 'Huang:'
    puts "  Distance  : #{@best.get_distance}"
    puts "  Time  : #{Time.now.to_i - @start_time} secs"
    puts "  Trails  : #{trails}"
  end
end