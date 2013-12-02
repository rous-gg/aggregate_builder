module AggregateBuilder
  class FieldBuilders::StringFieldBuilder < FieldBuilders::PrimitiveFieldBuilder

    def self.cast(field_name, value)
      if value.is_a?(String)
        value
      elsif value.is_a?(Symbol)
        value.to_s
      elsif value.nil?
        raise Errors::TypeCastingError, "#{field_name} can't be nil"
      else
        raise Errors::TypeCastingError, "Expected to be a string value, got #{value.inspect} for #{field_name}"
      end
    end

  end
end
