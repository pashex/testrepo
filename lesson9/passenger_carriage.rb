# Railroad passenger carriage
class PassengerCarriage < Carriage
  MSG = {
    invalid_seats: 'Количество мест должно быть больше 3 и не более 100'
  }.freeze

  attr_reader :seats, :taken_seats
  alias taken taken_seats

  def initialize(uid, seats)
    @seats = seats.to_i
    @taken_seats = 0
    super uid
  end

  def type
    'passenger'
  end

  def take_seat!
    if free_seats.zero?
      raise Validation::Error, 'Нельзя занять место. Свободных мест нет'
    end

    self.taken_seats += 1
  end

  def free_seats
    seats - taken_seats
  end
  alias free free_seats

  private

  attr_writer :taken_seats

  def validate!
    super
    validation_fail!(MSG[:invalid_seats]) if seats < 4 || seats > 100
  end
end
