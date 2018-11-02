# Module for Carriage actions
module CarriageActions
  private

  def create_passenger_carriage
    puts 'Уникальный идентификатор вагона:'
    uid = gets.chomp
    return puts("Вагон #{uid} уже есть") if find_carriage(uid)

    puts 'Количество мест в вагоне:'
    seats = gets.chomp
    carriages << PassengerCarriage.new(uid, seats)
    puts "Пассажирский вагон #{uid} успешно создан и готов к подцепке"
  rescue Validation::Error => e
    puts e.message
    retry
  end

  def create_cargo_carriage
    puts 'Уникальный идентификатор вагона:'
    uid = gets.chomp
    return puts("Вагон #{uid} уже есть") if find_carriage(uid)

    puts 'Объем товарного вагона:'
    volume = gets.chomp
    carriages << CargoCarriage.new(uid, volume)
    puts "Товарный вагон #{uid} успешно создан и готов к подцепке"
  rescue Validation::Error => e
    puts e.message
    retry
  end

  def delete_carriage
    carriage = input_carriage
    return unless carriage

    train = train_with_carriage(carriage)
    if train
      return puts("Вагон #{carriage.uid} в составе поезда #{train.number}. \
Для удаления, необходимо его предварительно отцепить")
    end

    carriages.delete(carriage)
    puts "Вагон #{carriage.uid} удалён"
  end

  def add_carriage
    train = input_train
    return unless train

    puts "Свободные вагоны: #{free_carriages.map(&:uid).join(', ')}"

    carriage = input_carriage
    return unless carriage

    train.attach!(carriage)
    puts "Вагон #{carriage.uid} подцеплен. Количество вагонов \
поезда #{train.number} - #{train.carriage_count}"
  rescue Validation::Error => e
    puts e.message
  end

  def remove_carriage
    train = input_train
    return unless train

    return puts('У поезда нет вагонов') if train.carriage_count.zero?

    carriage = train.detach!
    return puts('Не удалось отцепить вагон') unless carriage

    puts "Вагон #{carriage.uid} отцеплён. Количество вагонов \
поезда #{train.number} - #{train.carriage_count}"
  end

  def take_seat_carriage
    carriage = input_carriage
    return unless carriage

    unless carriage.type == 'passenger'
      return puts("Вагон #{uid} не является пассажирским")
    end

    carriage.take_seat!
    puts "Место успешно занято. Количество свободных мест \
вагона - #{carriage.free_seats}"
  rescue Validation::Error => e
    puts e.message
  end

  def take_volume_carriage
    carriage = input_carriage
    return unless carriage

    return puts('Вагон не является товарным') unless carriage.type == 'cargo'

    puts "Какой объем занять (доступно #{carriage.free_volume}):"
    use_volume = gets.chomp.to_f
    carriage.take_volume!(use_volume)
    puts "Объём успешно занят. Доступный объём - #{carriage.free_volume}"
  rescue Validation::Error => e
    puts e.message
  end
end
