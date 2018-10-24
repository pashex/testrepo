class Carriage
  include Manufacturer
  include Validation

  attr_reader :uid

  def initialize(uid)
    @uid = uid.to_s.strip
    validate!
  end

  private

  def validate!
    raise Validation::Error.new('Идентификатор вагона не может быть пустым') if uid.length.zero?
    raise Validation::Error.new('Идентификатор должен быть не менее 3-х символов') if uid.length < 3
  end
end
