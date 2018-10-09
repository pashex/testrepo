class Train
  include Manufacturer
  include InstanceCounter

  attr_reader :number, :speed, :current_station, :route, :carriages

  @@objects = []

  def self.find(number)
    @@objects.find { |train| train.number == number }
  end

  def initialize(number)
    @number = number.to_s
    @speed = 0
    @carriages = []
    @@objects << self
    register_instance
  end

  def carriage_count
    carriages.count
  end

  def inc_speed(delta = 1)
    @speed += delta
  end

  def stop
    @speed = 0
  end

  def attach(carriage)
    return if carriages.include?(carriage)
    carriages << carriage if stopped? && right_type_of?(carriage)
  end

  def detach
    carriages.pop if stopped?
  end

  def route=(route)
    return @route if @route == route
    @route = route
    current_station.leave(self) if current_station
    if route
      self.current_station = route.first_station
      current_station.take(self)
    else
      self.current_station = nil
    end
    route
  end

  def move(direction = 1)
    return unless [-1, 1].include?(direction)
    if current_station && new_station = route.station_through(direction, current_station)
      current_station.leave(self)
      self.current_station = new_station
      current_station.take(self)
      current_station
    end
  end

  def next_station
    current_station && route.station_through(1, current_station)
  end

  def prev_station
    current_station && route.station_through(-1, current_station)
  end

  def stopped?
    speed == 0
  end

  private

  attr_writer :current_station

  def right_type_of?(carriage)
    carriage.type == type
  end
end
