# Module contains new extended accessor methods
module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  class TypeError < StandardError; end

  # class methods
  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        history = "#{name}_history".to_sym
        history_var = "@#{history}".to_sym

        define_method(name) { instance_variable_get("@#{name}".to_sym) }
        define_method(history) { instance_variable_get(history_var) }

        define_method("#{name}=".to_sym) do |value|
          instance_variable_set("@#{name}".to_sym, value)
          instance_variable_set(
            history_var, instance_variable_get(history_var).to_a << value
          )
        end
      end
    end

    def strong_attr_accessor(name, class_obj)
      define_method(name) { instance_variable_get("@#{name}".to_sym) }

      define_method("#{name}=".to_sym) do |value|
        unless value.class == class_obj
          raise Accessors::TypeError, 'Invalid value type'
        end

        instance_variable_set("@#{name}".to_sym, value)
      end
    end
  end
end
