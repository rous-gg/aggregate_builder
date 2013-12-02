module AggregateBuilder
  class FieldBuilders::IntegerFieldBuilder < FieldBuilders::PrimitiveFieldBuilder

    def self.cast(field_name, value)
      if value.is_a?(Integer)
        value
      elsif value.is_a?(String)
        Integer(value)
      elsif value.nil?
        raise Errors::TypeCastingError, "#{field_name} can't be nil"
      else
        raise Errors::TypeCastingError, "Expected to be an integer value, got #{value.inspect} for #{field_name}"
      end
    rescue => e
      raise Errors::TypeCastingError, "Expected to be an integer value, got #{value.inspect} for #{field_name}"
    end

  end
end
