class PassengerCarriage < Carriage
  attr_reader :seats, :taken_seats

  def initialize(uid, seats)
    @seats = seats.to_i
    @taken_seats = 0
    super uid
  end

  def type
    'passenger'
  end

  def take_seat!
    raise Validation::Error.new('Нельзя занять место. Свободных мест нет') if free_seats.zero?
    self.taken_seats += 1
  end

  def free_seats
    seats - taken_seats
  end

  private

  attr_writer :taken_seats

  def validate!
    super
    raise Validation::Error.new('Количество мест в вагоне должно быть не менее 4 и не более 100') if seats < 4 || seats > 100
  end

end
