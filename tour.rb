require './city.rb'
require './tour_manager.rb'

class Tour
  attr_reader :tour

  def initialize(tour = nil)
    @tour = Array.new
    @distance = 0

    if tour.nil?
      TourManager.number_of_cities.times do
        @tour.push(nil)
      end
    else
      @tour = tour.clone
    end
  end

  def generate_individual
    TourManager.number_of_cities.times do |i|
      set_city(i, TourManager.get_city(i))
    end
    @tour.shuffle!
  end

  def set_city(index, city)
    @tour[index]  = city
    @distance = 0
  end

  def get_distance
    if @distance == 0
      tour_distance  = 0
      tour_size.times do |i|
        from  = @tour[i]

        if (i + 1 < tour_size)
          destination = @tour[i + 1]
        else
          destination = @tour[0]
        end

        tour_distance  += from.distance_to(destination)
      end
      @distance = tour_distance
    end
    return @distance
  end

  def tour_size
    @tour.size
  end
end