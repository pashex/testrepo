# Railroad route
class Route
  include InstanceCounter
  include Validation

  MSG = {
    same_nodes: 'Начало и конец маршрута не могут совпадать',
    err_remove: 'Станции нет в маршруте, невозможно удалить',
    err_remove_ends: 'Разрешается удалять только промежуточные станции',
    err_position: 'Невозможно поставить станцию на это место',
    err_exist_station: 'Станция уже присутствует в маршруте'
  }.freeze

  attr_reader :stations

  validate :stations, :each_type, Station

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

  def add_station_at!(position, station)
    validation_fail!(MSG[:err_exist_station]) if stations.include?(station)

    if position < 2 || position > stations.count
      validation_fail!(MSG[:err_position])
    end

    stations.insert(position - 1, station)
  end

  def remove_station!(station)
    validation_fail!(MSG[:err_remove]) unless stations.include?(station)

    if [first_station, last_station].include?(station)
      validation_fail!(MSG[:err_remove_ends])
    end

    stations.delete(station)
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
    super

    validation_fail!(MSG[:same_nodes]) if first_station == last_station
  end
end
