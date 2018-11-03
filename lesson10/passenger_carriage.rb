# Railroad passenger carriage
class PassengerCarriage < Carriage
  attr_reader :seats, :taken_seats
  alias taken taken_seats

  validate :seats, :range, 4, 100

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
end
