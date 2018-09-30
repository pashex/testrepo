class Railroad
  attr_reader :stations, :trains, :routes

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def menu(menu_action = :none)
    loop do
      puts "\nВаш выбор:"
      puts choices(menu_action)
      choice = gets.chomp
      return if exit_choice?(choice)
      do_choice(menu_action, choice.to_i)
    end
  end

  def seed
    stations_route_1 = %w(Уфа Аша Кропачёво Златоуст Миасс Челябинск).map { |name| Station.new(name) }
    stations_route_2 = %w(Каменск-Уральский Екатеринбург).map { |name| Station.new(name) }
    stations_route_3 = %w(Кыштым Касли).map { |name| Station.new(name) }

    route_1 = Route.new(stations_route_1.first, stations_route_1.last)
    stations_route_1[1..-2].each_with_index { |station, index| route_1.add_station_at(index + 1, station) }

    route_2 = Route.new(stations_route_1.last, stations_route_2.last)
    stations_route_2[0..-2].each_with_index { |station, index| route_2.add_station_at(index + 1, station) }

    route_3 = Route.new(stations_route_1.last, stations_route_2.last)
    stations_route_3.each_with_index { |station, index| route_3.add_station_at(index + 1, station) }

    passenger_trains = [13, 59, 211, 456].map { |number| PassengerTrain.new(number) }
    cargo_trains = [648, 950].map { |number| CargoTrain.new(number) }

    passenger_trains.each { |train| rand(20).times { train.attach(PassengerCarriage.new) } }
    cargo_trains.each { |train| rand(20).times { train.attach(CargoCarriage.new) } }

    passenger_trains[0..-2].each { |train| train.route = route_1 }
    passenger_trains[-1].route = route_2
    cargo_trains.each { |train| train.route = route_3 }

    @stations = [stations_route_1, stations_route_2, stations_route_3].flatten
    @trains = [passenger_trains, cargo_trains].flatten
    @routes = [route_1, route_2, route_3]
  end

  private

  EXIT_CHOICE = { choice: 0, name: 'Вернуться назад' }
  CHOICES =
    {
      none: [
        { choice: 1, type: :stations, name: 'Работа со станциями' },
        { choice: 2, type: :trains, name: 'Работа с поездами' },
        { choice: 3, type: :routes, name: 'Работа с маршрутами' },
        { choice: 4, type: :seed, name: 'Сброс к сид-данным (загрузить шаблон)' }
      ],
      stations: [
        { choice: 1, type: :stations, action: :index, name: 'Посмотреть все станции' },
        { choice: 2, type: :station, action: :create, name: 'Создать новую станцию' },
        { choice: 3, type: :station, action: :show, name: 'Посмотреть список поездов на станции' },
        { choice: 4, type: :station, action: :delete, name: 'Удалить станцию' }
      ],
      trains: [
        { choice: 1, type: :trains, action: :index, name: 'Посмотреть все поезда' },
        { choice: 2, type: :train, action: :create, name: 'Создать новый поезд' },
        { choice: 3, type: :train, action: :update, name: 'Изменить поезд' },
        { choice: 4, type: :train, action: :control, name: 'Управлять поездом' },
        { choice: 5, type: :train, action: :delete, name: 'Удалить поезд' }
      ],
      routes: [
        { choice: 1, type: :routes, action: :index, name: 'Посмотреть все маршруты' },
        { choice: 2, type: :route, action: :create, name: 'Создать новый маршрут' },
        { choice: 3, type: :route, action: :update, name: 'Изменить маршрут' },
        { choice: 4, type: :route, action: :delete, name: 'Удалить маршрут' }
      ],
      update_route: [
        { choice: 1, type: :route, action: :add_station, name: 'Добавить станцию в маршрут' },
        { choice: 2, type: :route, action: :remove_station, name: 'Удалить станцию из маршрута' }
      ],
      create_train: [
        { choice: 1, type: :train, action: :create_passenger, name: 'Создать пассажирский поезд' },
        { choice: 2, type: :train, action: :create_cargo, name: 'Создать грузовой поезд' }
      ],
      update_train: [
        { choice: 1, type: :train, action: :add_carriage, name: 'Добавить вагон в конец' },
        { choice: 2, type: :train, action: :remove_carriage, name: 'Отцепить последний вагон' }
      ],
      control_train: [
        { choice: 1, type: :train, action: :change_route, name: 'Назначить маршрут' },
        { choice: 2, type: :train, action: :remove_route, name: 'Снять с маршрута' },
        { choice: 3, type: :train, action: :move_forward, name: 'Переместить поезд по маршруту вперед' },
        { choice: 4, type: :train, action: :move_back, name: 'Переместить поезд по маршруту назад' }
      ]
    }

  def choices(menu_action)
    (CHOICES[menu_action].to_a + [EXIT_CHOICE]).map { |hash| "#{hash[:choice]} - #{hash[:name]}" }
  end

  def do_choice(menu_action, choice)
    selected = CHOICES[menu_action].to_a.find { |hash| hash[:choice] == choice }
    return unless selected
    selected_menu_action = [selected[:action], selected[:type]].compact.join('_').to_sym
    if CHOICES[selected_menu_action]
      menu(selected_menu_action)
    else
      self.send(selected_menu_action)
    end
  end

  def exit_choice?(choice)
    choice == '0'
  end

  def index_stations
    puts "Станции: #{@stations.join(', ')}"
  end

  def create_station
    station = get_station
    return puts("Станция #{station} уже есть") if station.is_a?(Station)
    @stations << Station.new(station)
    puts "Станция #{station} успешно создана"
  end

  %w(show_station delete_station).each do |method|
    define_method method do
      station = get_station
      return puts("Станции #{station} нет") unless station.is_a?(Station)
      self.send("#{method}!", station)
    end
  end

  def show_station!(station)
    puts "Пассажирские поезда на станции: #{station.trains('passenger').join(', ')}"
    puts "Грузовые поезда на станции: #{station.trains('cargo').join(', ')}"
  end

  def delete_station!(station)
    return puts('Удалить нельзя, т.к на станции есть поезда') if station.trains.any?
    return puts('Удалить нельзя, т.к станция входит в один из маршрутов') if routes_has_station?(station)
    @stations.delete(station)
    puts "Станция #{station.name} удалена"
  end

  def index_trains
    puts "Поезда: #{@trains.join(', ')}"
  end

  %w(delete_train change_route_train remove_route_train add_carriage_train remove_carriage_train move_forward_train move_back_train).each do |method|
    define_method method do
      train = get_train
      return puts("Поезда #{train} нет") unless train.is_a?(Train)
      self.send("#{method}!", train)
    end
  end

  %w(passenger cargo).each do |type|
    define_method "create_#{type}_train" do
      train = get_train
      return puts("Поезд #{train} уже есть") if train.is_a?(Train)
      @trains << Object.const_get("#{type.capitalize}Train").new(train)
      puts "Поезд #{train} успешно создан"
    end
  end

  def delete_train!(train)
    return puts("Поезд #{train} стоит на станции. Для удаления, необходимо его предварительно снять с маршрута") if train.current_station
    @trains.delete(train)
    puts "Поезд #{train} удалён"
  end

  def change_route_train!(train)
    route = get_route
    if route
      train.route = route
      puts "Маршрут поезда #{train} изменён на #{route}"
    else
      puts "Маршрут поезда #{train} не изменён"
    end
  end

  def remove_route_train!(train)
    train.route = nil
    puts "Поезд #{train} снят с маршрута"
  end

  def add_carriage_train!(train)
    carriage = case train.type
               when 'passenger'
                 PassengerCarriage.new
               when 'cargo'
                 CargoCarriage.new
               end
    if train.attach(carriage)
      puts "Вагон добавлен. Количество вагонов поезда #{train} - #{train.carriage_count}"
    else
      puts "Не удалось добавить вагон. Возможно, поезд в движении"
    end
  end

  def remove_carriage_train!(train)
    return puts("У поезда #{train} нет вагонов") if train.carriage_count.zero?
    if train.detach
      puts "Вагон отцеплён. Количество вагонов поезда #{train} - #{train.carriage_count}"
    else
      puts "Не удалось отцепить вагон. Возможно, поезд в движении"
    end
  end

  def move_forward_train!(train)
    return puts("У поезда #{train} нет маршрута") unless train.route
    if train.move(1)
      puts "Поезд #{train} - перешёл на станцию #{train.current_station}"
    else
      puts "Поезд уже на конечной станции (#{train.current_station})"
    end
  end

  def move_back_train!(train)
    return puts("У поезда #{train} нет маршрута") unless train.route
    if train.move(-1)
      puts "Поезд #{train} - перешёл на станцию #{train.current_station}"
    else
      puts "Поезд уже на начальной станции (#{train.current_station})"
    end
  end

  def index_routes
    puts "Маршруты:"
    puts @routes
  end

  def create_route
    first_station, last_station = %w(начальной конечной).map do |question|
      puts "Имя #{question} станции маршрута:"
      name = gets.chomp
      station = find_station_by_name(name)
      return puts("Станция #{name} не найдена, вначале создайте её") unless station
      station
    end
    return puts("Начальная станция не может совпадать с конечной") if first_station == last_station
    route = Route.new(first_station, last_station)
    @routes << route
    puts "Маршрут #{route} создан"
  end

  def delete_route
    return unless route = get_route
    return puts("Нельзя удалить маршрут, который назначен поездам. Снимите поезда с маршрута") if trains_have_route?(route)
    @routes.delete(route)
    puts "Маршрут #{route} удалён"
  end

  def add_station_route
    return unless route = get_route
    puts "Имя станции для добавления в маршрут:"
    name = gets.chomp
    station = find_station_by_name(name)
    return puts("Станция #{name} не найдена, вначале создайте её") unless station
    return puts("Станция #{station} уже присутствует в маршруте") if route.stations.include?(station)
    puts "Место, куда вставить станцию (номер по счёту с начала маршрута)"
    position = gets.chomp.to_i
    if route.add_station_at(position, station)
      puts "Маршрут обновлен: #{route}"
    else
      puts "Невозможно поставить станцию на это место. Возможно, вы ставите станцию в начало или конец"
    end
  end

  def remove_station_route
    return unless route = get_route
    puts "Имя станции для удаления из маршрута:"
    name = gets.chomp
    station = find_station_by_name(name)
    return puts("Станции #{name} не существует") unless station
    return puts("Станции #{station} нет в маршруте") unless route.stations.include?(station)
    if route.remove_station(station)
      puts "Маршрут обновлен: #{route}"
    else
      puts "Невозможно удалить станцию. Возможно вы пытаетесь удалить из маршрута начальную или конечную станцию"
    end
  end

  def get_station
    puts "Имя станции:"
    name = gets.chomp
    find_station_by_name(name) || name
  end

  def get_train
    puts "Номер поезда:"
    number = gets.chomp
    find_train_by_number(number) || number
  end

  def get_route
    return puts("Маршрутов нет, создайте хотя бы один") if @routes.empty?
    loop do
      @routes.each_with_index { |route, index| puts "#{index + 1} - #{route}" }
      puts "Ваш выбор (0 - отмена):"
      choice = gets.chomp
      return if exit_choice?(choice)
      route = @routes[choice.to_i - 1] if choice.to_i > 0
      return route if route
    end
  end

  def find_station_by_name(name)
    @stations.find { |s| s.name == name }
  end

  def routes_has_station?(station)
    @routes.map(&:stations).flatten.uniq.include?(station)
  end

  def find_train_by_number(number)
    @trains.find { |s| s.number == number }
  end

  def trains_have_route?(route)
    @trains.map(&:route).include?(route)
  end
end
