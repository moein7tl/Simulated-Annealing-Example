require './tour.rb'
require './simulated_annealing.rb'
require './simple_simulated_annealing.rb'
require './huang_simulated_annealing.rb'
require './adaptive_simulated_annealing.rb'

51.times do
  TourManager.add_city(City.new)
end

init_solution = Tour.new
init_solution.generate_individual
puts 'Initial solution distance: ' + init_solution.get_distance.to_s

SimpleSimulatedAnnealing.new(init_solution).run
HuangSimulatedAnnealing.new(init_solution,1000).run
AdaptiveSimulatedAnnealing.new(init_solution).run
