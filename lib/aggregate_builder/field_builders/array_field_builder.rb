module AggregateBuilder
  class FieldBuilders::ArrayFieldBuilder < FieldBuilders::PrimitiveFieldBuilder

    def self.cast(field, value)
      if value.is_a?(Array) || value.nil?
        value
      else
        raise Errors::TypeCastingError, "Expected to be an array, got #{value.inspect} for #{field.field_name}"
      end
    end

  end
end
