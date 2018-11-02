# Railroad carriage
class Carriage
  include Manufacturer
  include Validation

  MSG = {
    empty_uid: 'Идентификатор вагона не может быть пустым',
    error_uid_length: 'Идентификатор должен быть не менее 3 символов'
  }.freeze

  attr_reader :uid

  def initialize(uid)
    @uid = uid.to_s.strip
    validate!
  end

  private

  def validate!
    validation_fail!(MSG[:empty_uid]) if uid.length.zero?
    validation_fail!(MSG[:error_uid_length]) if uid.length < 3
  end
end
