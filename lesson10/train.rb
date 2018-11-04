# Railroad train
class Train
  require_relative 'station.rb'
  require_relative 'route.rb'

  include Manufacturer
  include InstanceCounter
  include Validation

  NUMBER_FORMAT = /\A[а-яa-z\d]{3}-?[а-яa-z\d]{2}\z/i
  MSG = { exists: 'Поезд с таким номером уже существует',
          exist_carriage: 'Данный вагон уже есть в поезде',
          other_attached: 'Вагон прицеплен к другому поезду',
          invalid_type: 'Неверный тип вагона',
          error_running: 'Ошибка прицепки/отцепки. Поезд в движении' }.freeze

  attr_reader :number, :speed, :current_station, :route, :carriages

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :route, :type, Route
  validate :current_station, :type, Station

  @objects = []

  class << self
    attr_reader :objects

    def find(number)
      objects.find { |train| train.number == number }
    end

    def find_attached(carriage)
      objects.find { |train| train.carriages.include?(carriage) }
    end
  end

  def initialize(number)
    @number = number.to_s.strip
    @speed = 0
    @carriages = []
    validate!
    validation_fail!(MSG[:exists]) if self.class.find(number)
    self.class.objects << self
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

  def attach!(carriage)
    validation_fail!(MSG[:exist_carriage]) if carriages.include?(carriage)
    validation_fail!(MSG[:other_attached]) if self.class.find_attached(carriage)
    validation_fail!(MSG[:invalid_type]) unless right_type_of?(carriage)
    validate_running!

    carriages << carriage
  end

  def detach!
    validate_running!
    carriages.pop
  end

  def route=(route)
    unless @route == route
      current_station.leave(self) if current_station
      if route
        self.current_station = route.first_station
        current_station.take(self)
      else
        self.current_station = nil
      end
    end
    @route = route
  end

  def move(direction = 1)
    return unless [-1, 1].include?(direction)
    return unless current_station

    new_station = route.station_through(direction, current_station)
    return unless new_station

    current_station.leave(self)
    self.current_station = new_station
    current_station.take(self)
    current_station
  end

  def next_station
    current_station && route.station_through(1, current_station)
  end

  def prev_station
    current_station && route.station_through(-1, current_station)
  end

  def stopped?
    speed.zero?
  end

  def each_carriage
    @carriages.each { |carriage| yield carriage }
  end

  private

  attr_writer :current_station

  def right_type_of?(carriage)
    carriage.type == type
  end

  def validate_running!
    validation_fail!(MSG[:error_running]) unless stopped?
  end
end
