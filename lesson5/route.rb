class Route
  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
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

end
