# Railroad carriage
class Carriage
  include Manufacturer
  include Validation

  attr_reader :uid
  validate :uid, :presence
  validate :uid, :length, 3

  def initialize(uid)
    @uid = uid.to_s.strip
    validate!
  end
end
