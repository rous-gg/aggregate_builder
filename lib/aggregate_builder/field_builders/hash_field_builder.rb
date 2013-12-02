module AggregateBuilder
  class FieldBuilders::HashFieldBuilder < FieldBuilders::PrimitiveFieldBuilder

    def self.cast(field_name, value)
      if value.is_a?(Hash)
        value
      elsif value.nil?
        raise Errors::TypeCastingError, "#{field_name} can't be nil"
      else
        raise Errors::TypeCastingError, "Expected to be a hash, got #{value.inspect} for #{field_name}"
      end
    end

  end
end
