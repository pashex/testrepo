# Module for Route actions
module RouteActions
  def index_routes
    puts 'Маршруты:'
    routes.each(&:show_stations)
  end

  def create_route
    first_station, last_station = %w[Начальная Конечная].map do |question|
      puts "#{question} станция маршрута"
      input_station
    end
    route = Route.new(first_station, last_station)
    routes << route
    puts 'Маршрут создан'
    route.show_stations
  rescue Validation::Error => e
    puts e.message
  end

  def delete_route
    route = input_route
    return unless route

    if trains_have_route?(route)
      return puts('Нельзя удалить маршрут, который назначен поездам. \
Снимите поезда с маршрута')
    end

    routes.delete(route)
    puts 'Данный маршрут:'
    route.show_stations
    puts 'Удалён'
  end

  def add_station_route
    route = input_route
    return unless route

    station = input_station
    return unless station

    puts 'Место, куда вставить станцию (номер по счёту с начала маршрута)'
    route.add_station_at!(gets.chomp.to_i, station)
    puts 'Маршрут обновлен:'
    route.show_stations
  rescue Validation::Error => e
    puts e.message
  end

  def remove_station_route
    route = input_route
    return unless route

    station = input_station
    return unless station

    route.remove_station!(station)
    puts 'Маршрут обновлен:'
    route.show_stations
  rescue Validation::Error => e
    puts e.message
  end
end
