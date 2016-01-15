require './city.rb'
require './tour_manager.rb'
require './tour.rb'
require './simulated_annealing.rb'

class AdaptiveSimulatedAnnealing < SimulatedAnnealing

  def initialize(init_solution)
    @start_time = Time.now.to_i
    @current_solution  = Tour.new(init_solution.tour)
    @limit1 = @current_solution.tour_size * 50
    @limit2 = @current_solution.tour_size * 500
    @limit3 = @current_solution.tour_size * 500
    @zeta = 1.01
    @theta = 10
    @k1 = 2
    @k2 = 4
    @mu1  = 10
    @mu2  = 5
    @lambda1  = 2
    @lambda2  = 0.9
  end

  def random_walk(max_tries)
    costs_list  = Array.new
    max_tries.times do
      new_solution  = random_neighbor(@current_solution)
      costs_list.push(new_solution.get_distance)
      @current_solution = new_solution if new_solution.get_distance < @current_solution.get_distance
    end
    return costs_list
    return SimulatedAnnealing.standard_deviation(costs_list)
  end

  def cost_changed_in_last_metropolis_chain
    @old_cost ||= 0
    if (@old_cost != @current_solution.get_distance)
      @old_cost = @current_solution.get_distance
      return true
    end
    return false
  end

  def run
    costs_list  = random_walk(@limit3)
    temperature = deviation = SimulatedAnnealing.standard_deviation(costs_list)
    prev_average_cost  = costs_list.inject{|sum,x| sum + x } / costs_list.size

    delta = deviation / @mu2
    @best = Tour.new(@current_solution.tour)
    equilibrium_not_reached = 0
    negative_temperature  = 0
    reinitializing  = 1
    alpha = @lambda1
    frozen = 0
    trails = 0
    loop do
      trails  +=  1
      costs_list  = metropolis(temperature, @limit1, @limit2)
      average_cost  = costs_list.inject{|sum,x| sum + x } / costs_list.size
      deviation = SimulatedAnnealing.standard_deviation(costs_list)

      if negative_temperature < @k2
        if reinitializing == 0
          if (average_cost / (prev_average_cost - delta)) > @zeta
            equilibrium_not_reached +=  1
          else
            equilibrium_not_reached = 0
          end

          if equilibrium_not_reached > @k1
            reinitializing  = 1
            alpha = @lambda1
            delta = deviation / @mu1
          elsif (temperature * delta) / (deviation ** 2) >= 1
            negative_temperature += 1
            reinitializing  = 1
            if negative_temperature < @k2
              alpha = @lambda1
              delta = deviation / @mu1
            else
              alpha = @lambda2
            end
          end

        else
          reinitializing  = 0
          prev_average_cost = average_cost
          alpha = 1 - (temperature * delta) / (deviation ** 2)
        end
      end

      temperature *=  alpha

      if cost_changed_in_last_metropolis_chain
        frozen = 0
      else
        frozen += 1
      end

      break if frozen >= @theta
    end

    puts 'Adaptive:'
    puts "  Distance  : #{@best.get_distance}"
    puts "  Time  : #{Time.now.to_i - @start_time} secs"
    puts "  Trails  : #{trails}"

  end
end