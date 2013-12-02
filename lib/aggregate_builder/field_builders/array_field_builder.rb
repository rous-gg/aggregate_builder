module AggregateBuilder
  class FieldBuilders::ArrayFieldBuilder < FieldBuilders::PrimitiveFieldBuilder

    def self.cast(field_name, value)
      if value.is_a?(Array) || value.nil?
        value
      else
        raise Errors::TypeCastingError, "Expected to be an array, got #{value.inspect} for #{field_name}"
      end
    end

  end
end
