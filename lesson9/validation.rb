module Validation
  class Error < StandardError; end

  def valid?
    validate!
  rescue Error
    false
  else
    true
  end

  protected

  def validate!
  end
end
