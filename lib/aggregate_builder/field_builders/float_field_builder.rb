module AggregateBuilder
  class FieldBuilders::FloatFieldBuilder < FieldBuilders::PrimitiveFieldBuilder

    def self.cast(value)
      if value.is_a?(Float) || value.nil?
        value
      elsif value.is_a?(String)
        Float(value)
      else
        raise Errors::TypeCastingError, "Expected to be a float value, got #{value}"
      end
    rescue => e
      raise Errors::TypeCastingError, "Expected to be a float value, got #{value}"
    end

  end
end
