class Train
  class InitializationInvalidError < StandardError; end

  attr_reader :type, :speed, :carriage_count, :current_station

  TYPES = %w(passenger freight)

  def initialize(number, type, carriage_count)
    raise InitializationInvalidError.new('Invalid train type. Must be passenger or freight') unless TYPES.include?(type)
    @number = number
    @type = type
    @speed = 0
    @carriage_count = carriage_count
  end

  def inc_speed(delta = 1)
    @speed += delta
  end

  def stop
    @speed = 0
  end

  def attach
    @carriage_count += 1 if speed == 0
  end

  def detach
    @carriage_count -= 1 if speed == 0 && @carriage_count > 0
  end

  def route=(route)
    return @route if @route == route
    @route = route
    @current_station.send(self) if @current_station
    @current_station = @route.first_station
    @current_station.take(self)
    @route
  end

  def move(direction = 1)
    return unless [-1, 1].include?(direction)
    if @current_station && @new_station = @route.station_through(direction, @current_station)
      @current_station.send(self)
      @current_station = @new_station
      @current_station.take(self)
      @current_station
    end
  end

  def next_station
    @current_station && @route.station_through(1, @current_station)
  end

  def prev_station
    @current_station && @route.station_through(-1, @current_station)
  end

  def to_s
    "#{@number.to_s} #{@type}"
  end
end
