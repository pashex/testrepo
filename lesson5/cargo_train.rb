class CargoTrain < Train
  def type
    'cargo'
  end

  private
  # Данный метод не должен вызываться извне, служит лишь для определения правильного типа вагона внутри класса
  def right_type_of?(carriage)
    carriage.is_a? CargoCarriage
  end
end
