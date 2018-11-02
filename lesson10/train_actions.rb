# Module for Train actions
module TrainActions
  private

  def index_trains
    trains.each do |train|
      puts "Поезд: #{train.number} (#{train.type}).\
Вагоны: #{train.carriages.map(&:uid).join(', ')}"
    end
  end

  def create_passenger_train
    create_train('Passenger')
  end

  def create_cargo_train
    create_train('Cargo')
  end

  def create_train(type)
    puts 'Номер поезда:'
    number = gets.chomp
    trains << Object.const_get("#{type}Train").new(number)
    puts "Поезд #{number} (#{type}) успешно создан"
  rescue Validation::Error => e
    puts e.message
    retry
  end

  def show_train
    train = input_train
    return unless train

    train.each_carriage do |carriage|
      puts "Номер: #{carriage.uid}; Тип: #{carriage.type}; \
Занято: #{carriage.taken}; Свободно: #{carriage.free}"
    end
  end

  def delete_train
    train = input_train
    return unless train

    if train.current_station
      return puts("Поезд #{train.number} стоит на станции. Для удаления,\
необходимо его предварительно снять с маршрута")
    end

    trains.delete(train)
    puts "Поезд #{train.number} удалён"
  end

  def change_route_train
    train = input_train
    return unless train

    route = input_route
    return puts("Маршрут поезда #{train.number} не изменён") unless route

    train.route = route
    puts "Маршрут поезда #{train.number} изменён. Новый маршрут:"
    route.show_stations
  end

  def remove_route_train
    train = input_train
    return unless train

    train.route = nil
    puts "Поезд #{train.number} снят с маршрута"
  end

  def move_forward_train
    train = input_train
    return unless train

    return puts("У поезда #{train.number} нет маршрута") unless train.route

    if train.move(1)
      puts "Поезд #{train.number} - перешёл на \
        станцию #{train.current_station.name}"
    else
      puts "Поезд уже на конечной станции (#{train.current_station.name})"
    end
  end

  def move_back_train
    train = input_train
    return unless train

    return puts("У поезда #{train.number} нет маршрута") unless train.route

    if train.move(-1)
      puts "Поезд #{train.number} - перешёл на \
станцию #{train.current_station.name}"
    else
      puts "Поезд уже на начальной станции (#{train.current_station.name})"
    end
  end
end
