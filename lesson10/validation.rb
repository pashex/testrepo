# Validation methods for classes
module Validation
  class Error < StandardError; end

  def valid?
    validate!
  rescue Error
    false
  else
    true
  end

  def validation_fail!(msg)
    raise Validation::Error, msg
  end

  protected

  def validate!; end
end
