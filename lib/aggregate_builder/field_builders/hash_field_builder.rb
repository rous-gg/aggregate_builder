module AggregateBuilder
  class FieldBuilders::HashFieldBuilder < FieldBuilders::PrimitiveFieldBuilder

    def self.cast(field_name, value)
      if value.is_a?(Hash) || value.nil?
        value
      else
        raise Errors::TypeCastingError, "Expected to be a hash, got #{value.inspect} for #{field_name}"
      end
    end

  end
end
