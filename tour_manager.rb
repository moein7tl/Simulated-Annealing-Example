require './city.rb'

class TourManager
  @@destination_cities = Array.new

  def self.add_city(city)
    @@destination_cities.push(city)
  end

  def self.get_city(index)
    @@destination_cities[index]
  end

  def self.number_of_cities
    @@destination_cities.size
  end
end