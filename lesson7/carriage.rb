class Carriage
  include Manufacturer
  attr_reader :uid

  def initialize(uid)
    @uid = uid
  end
end
