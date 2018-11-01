# Railroad
class Railroad
  include Menu
  include Seeder
  include StationActions
  include TrainActions
  include CarriageActions
  include RouteActions

  attr_reader :stations, :trains, :routes, :carriages

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @carriages = []
  end

  def seed
    @stations = seed_stations('Уфа Миасс Челябинск Каменск-Урал Екатеринбург')
    @routes = [seed_route(@stations[0..2]), seed_route(@stations[2..4])]

    @trains = seed_trains(passenger: 'РЖД-13 РЖД-59 РЖД-21 РЖД-56',
                          cargo: '648-56 950-23')

    @carriages = seed_carriages(passenger: 'ПВ1 ПВ2 ПВ3 ПВ4 ПВ5', seats: 36,
                                cargo: 'ТВ1 ТВ2 ТВ3 ТВ4', volume: 100)

    attach_carriages(@trains, @carriages[0..3] + @carriages[5..6])
    set_routes(@trains, @routes)
  end

  private

  def input_station
    puts 'Имя станции:'
    name = gets.chomp
    find_station(name) || puts("Станции #{name} нет")
  end

  def input_train
    puts 'Номер поезда:'
    number = gets.chomp
    find_train(number) || puts("Поезда #{number} нет")
  end

  def input_carriage
    puts 'Идентификатор вагона:'
    uid = gets.chomp
    find_carriage(uid) || puts("Вагона #{uid} нет")
  end

  def input_route
    return puts('Маршрутов нет, создайте хотя бы один') if @routes.empty?

    loop do
      puts_routes_menu
      choice = gets.chomp
      return if exit_choice?(choice)

      route = @routes[choice.to_i - 1] if choice.to_i > 0
      return route if route
    end
  end

  def puts_routes_menu
    routes.each_with_index do |route, index|
      print("#{index + 1} - ")
      route.show_stations
    end
    puts 'Ваш выбор (0 - отмена):'
  end

  def find_station(name)
    stations.find { |s| s.name == name }
  end

  def find_carriage(uid)
    carriages.find { |c| c.uid == uid }
  end

  def find_train(number)
    trains.find { |s| s.number == number }
  end

  def routes_have_station?(station)
    routes.map(&:stations).flatten.uniq.include?(station)
  end

  def trains_have_route?(route)
    trains.map(&:route).include?(route)
  end

  def free_carriages
    carriages.select { |carriage| Train.find_attached(carriage).nil? }
  end
end
