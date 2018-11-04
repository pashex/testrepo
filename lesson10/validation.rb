# Validation methods for classes
module Validation
  def self.included(base)
    base.extend ClassMethods
  end

  class Error < StandardError; end

  # class methods
  module ClassMethods
    VALIDATION_TYPES = %i[presence format type each_type length range].freeze

    def validate(attr, type, *params)
      return unless VALIDATION_TYPES.include?(type)

      validations[type] << [attr, *params]
    end

    private

    def validations
      @validations ||= {}
      VALIDATION_TYPES.each { |key| @validations[key] ||= [] }
      @validations
    end
  end

  def valid?
    validate!
  rescue Error
    false
  else
    true
  end

  def validate!
    self.class.send(:validations).each do |type, type_validations|
      type_validations.each do |attr, *params|
        msg = send("validate_#{type}".to_sym, attr, instance_variable_get("@#{attr}"), *params)
        validation_fail!(msg) if msg
      end
    end
  end

  protected

  def validation_fail!(msg)
    raise Validation::Error, msg
  end

  private

  def validate_presence(attr, value)
    "#{attr} не должен быть пустым" if value.to_s.strip == ''
  end

  def validate_format(attr, value, format)
    raise 'Неверный формат в конструкции validate' unless format.is_a?(Regexp)
    return if value.nil?

    "#{attr} должен быть типа String" unless value.is_a?(String)
    "#{attr} не соответствует формату #{format}" if value !~ format
  end

  def validate_type(attr, value, class_name)
    raise 'Неверный класс в конструкции validate' unless class_name.is_a?(Class)

    return if value.nil?

    "#{attr} должен быть типа #{class_name}" unless value.is_a?(class_name)
  end

  def validate_each_type(attr, value, class_name)
    raise 'Неверный класс в конструкции validate' unless class_name.is_a?(Class)

    return if value.to_a.all? { |o| o.is_a?(class_name) }

    "Каждый объект из #{attr} должен быть типа #{class_name}"
  end

  def validate_length(attr, value, min, max = nil)
    return if value.nil?

    if min.is_a?(Integer) && value.length < min
      return "Длина #{attr} должна быть не меньше #{min}"
    end

    if max.is_a?(Integer) && value.length > max
      "Длина #{attr} должна быть не больше #{max}"
    end
  end

  def validate_range(attr, value, min, max = nil)
    return if value.nil?

    return "#{attr} должен быть не меньше #{min}" if min.is_a?(Numeric) && value < min

    "#{attr} должен быть не больше #{max}" if max.is_a?(Numeric) && value > max
  end
end
