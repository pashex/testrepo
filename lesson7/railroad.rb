class Railroad
  attr_reader :stations, :trains, :routes, :carriages

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @carriages = []
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

    passenger_carriages = %w(П1 П2 П3 П4 П5).map { |uid| PassengerCarriage.new(uid) }
    cargo_carriages = %w(Т1 Т2 Т3 Т4).map { |uid| CargoCarriage.new(uid) }

    passenger_trains.each_with_index { |train, index| train.attach(passenger_carriages[index]) }
    cargo_trains.each_with_index { |train, index| train.attach(cargo_carriages[index]) }

    passenger_trains[0..-2].each { |train| train.route = route_1 }
    passenger_trains[-1].route = route_2
    cargo_trains.each { |train| train.route = route_3 }

    @stations = [stations_route_1, stations_route_2, stations_route_3].flatten
    @trains = [passenger_trains, cargo_trains].flatten
    @routes = [route_1, route_2, route_3]
    @carriages = [passenger_carriages, cargo_carriages].flatten
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
        { choice: 1, type: :train, action: :create_passenger_carriage, name: 'Создать пассажирский вагон' },
        { choice: 2, type: :train, action: :create_cargo_carriage, name: 'Создать товарный вагон' },
        { choice: 3, type: :train, action: :delete_carriage, name: 'Удалить свободный вагон' },
        { choice: 4, type: :train, action: :add_carriage, name: 'Добавить вагон в конец' },
        { choice: 5, type: :train, action: :remove_carriage, name: 'Отцепить последний вагон' }
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
    puts "Станции: #{@stations.map(&:name).join(', ')}"
  end

  def create_station
    puts "Название станции:"
    name = gets.chomp
    return puts("Станция #{name} уже есть") if find_station(name)
    @stations << Station.new(name)
    puts "Станция #{name} успешно создана"
  end

  def show_station
    return unless station = get_station
    puts "Пассажирские поезда на станции: #{station.trains('passenger').map(&:number).join(', ')}"
    puts "Грузовые поезда на станции: #{station.trains('cargo').map(&:number).join(', ')}"
  end

  def delete_station
    return unless station = get_station
    return puts('Удалить нельзя, т.к на станции есть поезда') if station.trains.any?
    return puts('Удалить нельзя, т.к станция входит в один из маршрутов') if routes_have_station?(station)
    @stations.delete(station)
    puts "Станция #{station.name} удалена"
  end

  def index_trains
    @trains.each do |train|
      puts "Поезд: #{train.number} (#{train.type}). Вагоны: #{train.carriages.map(&:uid).join(', ')}"
    end
  end

  def create_passenger_train
    create_train('Passenger')
  end

  def create_cargo_train
    create_train('Cargo')
  end

  def create_train(type)
    puts "Номер поезда:"
    number = gets.chomp
    @trains << Object.const_get("#{type}Train").new(number)
    puts "Поезд #{number} (#{type}) успешно создан"
  rescue Validation::Error => e
    puts e.message
    retry
  end

  def delete_train
    return unless train = get_train
    return puts("Поезд #{train.number} стоит на станции. Для удаления, необходимо его предварительно снять с маршрута") if train.current_station
    @trains.delete(train)
    puts "Поезд #{train.number} удалён"
  end

  def change_route_train
    return unless train = get_train
    route = get_route
    return puts("Маршрут поезда #{train.number} не изменён") unless route
    train.route = route
    puts "Маршрут поезда #{train.number} изменён. Новый маршрут:"
    route.show_stations
  end

  def remove_route_train
    return unless train = get_train
    train.route = nil
    puts "Поезд #{train.number} снят с маршрута"
  end

  def create_passenger_carriage_train
    create_carriage('Passenger')
  end

  def create_cargo_carriage_train
    create_carriage('Cargo')
  end

  def create_carriage(type)
    puts "Уникальный идентификатор вагона:"
    uid = gets.chomp
    return puts("Вагон #{uid} уже есть") if find_carriage(uid)
    @carriages << Object.const_get("#{type}Carriage").new(uid)
    puts "Вагон с идентификатором #{uid} (#{type}) успешно создан и готов к подцепке"
  end

  def delete_carriage_train
    return unless carriage = get_carriage
    train = train_with_carriage(carriage)
    return puts("Вагон #{carriage.uid} в составе поезда #{train.number}. Для удаления, необходимо его предварительно отцепить") if train
    @carriages.delete(carriage)
    puts "Вагон #{carriage.uid} удалён"
  end

  def add_carriage_train
    puts "Свободные вагоны для подцепки: #{free_carriages.map(&:uid).join(', ')}"
    return unless carriage = get_carriage
    train = train_with_carriage(carriage)
    return puts("Вагон #{carriage.uid} в составе поезда #{train.number}. Подцепить можно только свободный вагон") if train
    return unless train = get_train
    return puts("Вагон #{carriage.uid} (#{carriage.type}) и поезд #{train.number} (#{train.type}) различных типов") unless train.type == carriage.type
    if train.attach(carriage)
      puts "Вагон #{carriage.uid} подцеплен. Количество вагонов поезда #{train.number} - #{train.carriage_count}"
    else
      puts "Не удалось подцепить вагон. Возможно, поезд в движении"
    end
  end

  def remove_carriage_train
    return unless train = get_train
    return puts("У поезда #{train.number} нет вагонов") if train.carriage_count.zero?
    if carriage = train.detach
      puts "Вагон #{carriage.uid} отцеплён. Количество вагонов поезда #{train.number} - #{train.carriage_count}"
    else
      puts "Не удалось отцепить вагон. Возможно, поезд в движении"
    end
  end

  def move_forward_train
    return unless train = get_train
    return puts("У поезда #{train.number} нет маршрута") unless train.route
    if train.move(1)
      puts "Поезд #{train.number} - перешёл на станцию #{train.current_station.name}"
    else
      puts "Поезд уже на конечной станции (#{train.current_station.name})"
    end
  end

  def move_back_train
    return unless train = get_train
    return puts("У поезда #{train.number} нет маршрута") unless train.route
    if train.move(-1)
      puts "Поезд #{train.number} - перешёл на станцию #{train.current_station.name}"
    else
      puts "Поезд уже на начальной станции (#{train.current_station.name})"
    end
  end

  def index_routes
    puts "Маршруты:"
    @routes.each(&:show_stations)
  end

  def create_route
    first_station, last_station = %w(Начальная Конечная).map do |question|
      puts "#{question} станция маршрута"
      return unless station = get_station
      station
    end
    return puts("Начальная станция не может совпадать с конечной") if first_station == last_station
    route = Route.new(first_station, last_station)
    @routes << route
    puts "Маршрут создан"
    route.show_stations
  end

  def delete_route
    return unless route = get_route
    return puts("Нельзя удалить маршрут, который назначен поездам. Снимите поезда с маршрута") if trains_have_route?(route)
    @routes.delete(route)
    puts "Данный маршрут:"
    route.show_stations
    puts "Удалён"
  end

  def add_station_route
    return unless route = get_route
    return unless station = get_station
    return puts("Станция #{station.name} уже присутствует в маршруте") if route.stations.include?(station)
    puts "Место, куда вставить станцию (номер по счёту с начала маршрута)"
    position = gets.chomp.to_i
    if route.add_station_at(position, station)
      puts "Маршрут обновлен:"
      route.show_stations
    else
      puts "Невозможно поставить станцию на это место. Возможно, вы ставите станцию в начало или конец"
    end
  end

  def remove_station_route
    return unless route = get_route
    return unless station = get_station
    return puts("Станции #{station} нет в маршруте") unless route.stations.include?(station)
    if route.remove_station(station)
      puts "Маршрут обновлен:"
      route.show_stations
    else
      puts "Невозможно удалить станцию. Возможно вы пытаетесь удалить из маршрута начальную или конечную станцию"
    end
  end

  def get_station
    puts "Имя станции:"
    name = gets.chomp
    find_station(name) || puts("Станции #{name} нет")
  end

  def get_train
    puts "Номер поезда:"
    number = gets.chomp
    find_train(number) || puts("Поезда #{number} нет")
  end

  def get_carriage
    puts "Идентификатор вагона:"
    uid = gets.chomp
    find_carriage(uid) || puts("Вагона #{uid} нет")
  end

  def get_route
    return puts("Маршрутов нет, создайте хотя бы один") if @routes.empty?
    loop do
      @routes.each_with_index { |route, index| print("#{index + 1} - "); route.show_stations }
      puts "Ваш выбор (0 - отмена):"
      choice = gets.chomp
      return if exit_choice?(choice)
      route = @routes[choice.to_i - 1] if choice.to_i > 0
      return route if route
    end
  end

  def find_station(name)
    @stations.find { |s| s.name == name }
  end

  def find_carriage(uid)
    @carriages.find { |c| c.uid == uid }
  end

  def find_train(number)
    @trains.find { |s| s.number == number }
  end

  def routes_have_station?(station)
    @routes.map(&:stations).flatten.uniq.include?(station)
  end

  def trains_have_route?(route)
    @trains.map(&:route).include?(route)
  end

  def train_with_carriage(carriage)
    @trains.find { |train| train.carriages.include?(carriage) }
  end

  def free_carriages
    @carriages.select { |carriage| train_with_carriage(carriage).nil? }
  end
end
