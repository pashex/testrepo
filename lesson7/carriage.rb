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
    raise Validation::Error.new('Идентификатор вагона не может быть пустым') if uid == ''
    raise Validation::Error.new('Идентификатор должен быть более 3-х символов') unless uid.length > 3
  end
end
