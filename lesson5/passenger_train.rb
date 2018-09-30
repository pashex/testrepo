class PassengerTrain < Train
  def type
    'passenger'
  end

  private

  def right_type_of?(carriage)
    carriage.is_a? PassengerCarriage
  end
end
