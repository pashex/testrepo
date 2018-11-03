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

      send("define_#{type}_validation".to_sym, attr, *params)
    end

    private

    def validations
      @validations ||= {}
      VALIDATION_TYPES.each { |key| @validations[key] ||= [] }
      @validations
    end

    def define_presence_validation(attr)
      define_method("validate_presence_#{attr}".to_sym) do |value|
        "#{attr} не должен быть пустым" if value.to_s.strip == ''
      end
      validations[:presence] << attr
    end

    def define_format_validation(attr, format)
      raise 'Неверный формат в конструкции validate' unless format.is_a?(Regexp)

      define_method("validate_format_#{attr}".to_sym) do |value|
        return if value.nil?

        "#{attr} должен быть типа String" unless value.is_a?(String)
        "#{attr} не соответствует формату #{format}" if value !~ format
      end
      validations[:format] << attr
    end

    def define_type_validation(attr, class_name)
      raise 'Неверный класс в конструкции validate' unless class_name.is_a?(Class)

      define_method("validate_type_#{attr}".to_sym) do |value|
        return if value.nil?

        "#{attr} должен быть типа #{class_name}" unless value.is_a?(class_name)
      end
      validations[:type] << attr
    end

    def define_each_type_validation(attr, class_name)
      raise 'Неверный класс в конструкции validate' unless class_name.is_a?(Class)

      define_method("validate_each_type_#{attr}".to_sym) do |value|
        unless value.to_a.all? { |o| o.is_a?(class_name) }
          "Каждый объект из #{attr} должен быть типа #{class_name}"
        end
      end
      validations[:each_type] << attr
    end

    def define_length_validation(attr, min, max = nil)
      define_method("validate_length_#{attr}".to_sym) do |value|
        return if value.nil?
        if min.is_a?(Integer) && value.length < min
          return "Длина #{attr} должна быть не меньше #{min}"
        end
        if max.is_a?(Integer) && value.length > max
          return "Длина #{attr} должна быть не больше #{max}"
        end
      end
      validations[:length] << attr
    end

    def define_range_validation(attr, min, max = nil)
      define_method("validate_range_#{attr}".to_sym) do |value|
        return if value.nil?
        return "#{attr} должен быть не меньше #{min}" if min.is_a?(Numeric) && value < min
        return "#{attr} должен быть не больше #{max}" if max.is_a?(Numeric) && value > max
      end
      validations[:range] << attr
    end
  end

  def valid?
    validate!
  rescue Error
    false
  else
    true
  end

  protected

  def validation_fail!(msg)
    raise Validation::Error, msg
  end

  def validate!
    self.class.send(:validations).each do |type, attrs|
      attrs.each do |attr|
        msg = send("validate_#{type}_#{attr}".to_sym, instance_variable_get("@#{attr}"))
        validation_fail!(msg) if msg
      end
    end
  end
end
