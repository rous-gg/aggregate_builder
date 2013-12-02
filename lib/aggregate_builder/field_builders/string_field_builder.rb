module AggregateBuilder
  class FieldBuilders::StringFieldBuilder < FieldBuilders::PrimitiveFieldBuilder

    def self.cast(field_name, value)
      if value.nil? || value.is_a?(String)
        value
      elsif value.is_a?(Symbol)
        value.to_s
      else
        raise Errors::TypeCastingError, "Expected to be a string value, got #{value.inspect} for #{field_name}"
      end
    end

  end
end
