module AggregateBuilder
  class FieldBuilders::FloatFieldBuilder < FieldBuilders::PrimitiveFieldBuilder

    def self.cast(field, value)
      if value.is_a?(Float) || value.nil?
        value
      elsif value.is_a?(String)
        Float(value)
      else
        raise Errors::TypeCastingError, "Expected to be a float value, got #{value.inspect} for #{field.field_name}"
      end
    rescue => e
      raise Errors::TypeCastingError, "Expected to be a float value, got #{value} for #{field.field_name}"
    end

  end
end
