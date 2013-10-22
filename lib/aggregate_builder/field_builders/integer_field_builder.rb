module AggregateBuilder
  class FieldBuilders::IntegerFieldBuilder < FieldBuilders::PrimitiveFieldBuilder

    def self.cast(field, value)
      if value.is_a?(Integer) || value.nil?
        value
      elsif value.is_a?(String)
        Integer(value)
      else
        raise Errors::TypeCastingError, "Expected to be an integer value, got #{value.inspect} for #{field.field_name}"
      end
    rescue => e
      raise Errors::TypeCastingError, "Expected to be an integer value, got #{value.inspect} for #{field.field_name}"
    end

  end
end
