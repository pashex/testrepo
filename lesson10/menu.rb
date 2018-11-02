# Module for menu methods
module Menu
  def menu(menu_action = :none)
    loop do
      puts "\nВаш выбор:"
      puts choices(menu_action)
      choice = gets.chomp
      exit_choice?(choice) ? return : do_choice(menu_action, choice.to_i)
    end
  end

  private

  EXIT_CHOICE = { choice: 0, name: 'Вернуться назад' }.freeze
  CHOICES =
    {
      none: [
        { choice: 1, type: :stations, name: 'Работа со станциями' },
        { choice: 2, type: :trains, name: 'Работа с поездами' },
        { choice: 3, type: :carriages, name: 'Работа с вагонами' },
        { choice: 4, type: :routes, name: 'Работа с маршрутами' },
        { choice: 5, type: :seed, name: 'Сброс (загрузить шаблон)' }
      ],
      stations: [
        { choice: 1, type: :stations, action: :index,
          name: 'Посмотреть все станции' },
        { choice: 2, type: :station, action: :create,
          name: 'Создать новую станцию' },
        { choice: 3, type: :station, action: :show,
          name: 'Посмотреть список поездов на станции' },
        { choice: 4, type: :station, action: :delete, name: 'Удалить станцию' }
      ],
      trains: [
        { choice: 1, type: :trains, action: :index,
          name: 'Посмотреть все поезда' },
        { choice: 2, type: :train, action: :create, name: 'Создать поезд' },
        { choice: 3, type: :train, action: :show,
          name: 'Посмотреть список вагонов поезда' },
        { choice: 4, type: :train, action: :control,
          name: 'Управлять поездом' },
        { choice: 5, type: :train, action: :delete, name: 'Удалить поезд' }
      ],
      carriages: [
        { choice: 1, type: :carriage, action: :create_passenger,
          name: 'Создать пассажирский вагон' },
        { choice: 2, type: :carriage, action: :create_cargo,
          name: 'Создать товарный вагон' },
        { choice: 3, type: :carriage, action: :delete,
          name: 'Удалить свободный вагон' },
        { choice: 4, type: :carriage, action: :add,
          name: 'Добавить вагон в конец поезда' },
        { choice: 5, type: :carriage, action: :remove,
          name: 'Отцепить последний вагон поезда' },
        { choice: 6, type: :carriage, action: :take_seat,
          name: 'Занять место в пассажирском вагоне' },
        { choice: 7, type: :carriage, action: :take_volume,
          name: 'Занять объём в товарном вагоне' }
      ],
      routes: [
        { choice: 1, type: :routes, action: :index,
          name: 'Посмотреть все маршруты' },
        { choice: 2, type: :route, action: :create, name: 'Создать маршрут' },
        { choice: 3, type: :route, action: :update, name: 'Изменить маршрут' },
        { choice: 4, type: :route, action: :delete, name: 'Удалить маршрут' }
      ],
      update_route: [
        { choice: 1, type: :route, action: :add_station,
          name: 'Добавить станцию в маршрут' },
        { choice: 2, type: :route, action: :remove_station,
          name: 'Удалить станцию из маршрута' }
      ],
      create_train: [
        { choice: 1, type: :train, action: :create_passenger,
          name: 'Создать пассажирский поезд' },
        { choice: 2, type: :train, action: :create_cargo,
          name: 'Создать грузовой поезд' }
      ],
      control_train: [
        { choice: 1, type: :train, action: :change_route,
          name: 'Назначить маршрут' },
        { choice: 2, type: :train, action: :remove_route,
          name: 'Снять с маршрута' },
        { choice: 3, type: :train, action: :move_forward,
          name: 'Переместить поезд по маршруту вперед' },
        { choice: 4, type: :train, action: :move_back,
          name: 'Переместить поезд по маршруту назад' }
      ]
    }.freeze

  def choices(menu_action)
    (CHOICES[menu_action].to_a + [EXIT_CHOICE]).map do |hash|
      "#{hash[:choice]} - #{hash[:name]}"
    end
  end

  def do_choice(menu_action, choice)
    selected = CHOICES[menu_action].to_a.find { |hash| hash[:choice] == choice }
    return unless selected

    selected_action = [
      selected[:action], selected[:type]
    ].compact.join('_').to_sym

    CHOICES[selected_action] ? menu(selected_action) : send(selected_action)
  end

  def exit_choice?(choice)
    choice == '0'
  end
end
