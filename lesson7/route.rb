class Route
  include InstanceCounter
  include Validation

  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
    validate!
    register_instance
  end

  def first_station
    stations.first
  end

  def last_station
    stations.last
  end

  def add_station_at(position, station)
    return if position < 2 || position > stations.count
    stations.insert(position - 1, station) unless stations.include?(station)
  end

  def remove_station(station)
    stations.delete(station) if stations[1..-2].include?(station)
  end

  def show_stations
    puts stations.map(&:name).join(', ')
  end

  def station_through(step, station)
    return unless stations.include?(station)
    new_station_index = stations.index(station) + step
    stations[new_station_index] unless new_station_index < 0
  end

  private

  def validate!
    raise Validation::Error.new('Узлы маршрута должны быть объектами класса Station') unless stations.all? { |s| s.is_a?(Station) }
    raise Validation::Error.new('Начало и конец маршрута не могут совпадать') if first_station == last_station
  end
end
