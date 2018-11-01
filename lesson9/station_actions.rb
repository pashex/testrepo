# Module for Station menu actions
module StationActions
  private

  def index_stations
    puts "Станции: #{stations.map(&:name).join(', ')}"
  end

  def create_station
    puts 'Название станции:'
    name = gets.chomp
    return puts("Станция #{name} уже есть") if find_station(name)

    stations << Station.new(name)
    puts "Станция #{name} успешно создана"
  end

  def show_station
    station = input_station
    return unless station

    station.each_train do |train|
      puts "Номер: #{train.number}; Тип: #{train.type};\
Кол-во вагонов: #{train.carriage_count}"
    end
  end

  def delete_station
    station = input_station
    return unless station
    if station.trains.any?
      return puts('Удалить нельзя, т.к на станции есть поезда')
    end

    if routes_have_station?(station)
      return puts('Удалить нельзя, т.к станция входит в один из маршрутов')
    end

    stations.delete(station)
    puts "Станция #{station.name} удалена"
  end
end
