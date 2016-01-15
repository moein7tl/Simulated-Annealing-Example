class City
  attr_reader :x, :y
  def initialize(x = nil, y = nil)
    @x  = x || rand(1000)
    @y  = y || rand(1000)
  end

  def distance_to(city)
    x_distance = (@x  - city.x).abs
    y_distance = (@y  - city.y).abs
    Math.sqrt(x_distance ** 2 + y_distance ** 2)
  end
end