module AggregateBuilder
  class FieldBuilders::HashFieldBuilder < FieldBuilders::PrimitiveFieldBuilder

    def self.cast(field, value)
      if value.is_a?(Hash) || value.nil?
        value
      else
        raise Errors::TypeCastingError, "Expected to be a hash, got #{value.inspect} for #{field.field_name}"
      end
    end

  end
end
