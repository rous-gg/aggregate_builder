module AggregateBuilder
  class FieldBuilders::TimeFieldBuilder < FieldBuilders::PrimitiveFieldBuilder
    TIME_REGEXP = /^([0-9]|0[0-9]|1[0-9]|2[0-3]):([0-5][0-9])(:[0-5][0-9])?$/

    def self.cast(field_name, value)
      if value.is_a?(String)
        unless !!TIME_REGEXP.match(value)
          raise Errors::TypeCastingError, "Expected to be a time, got #{value.inspect} for #{field_name}"
        end
        value
      elsif value.nil?
        raise Errors::TypeCastingError, "#{field_name} can't be nil"
      else
        raise Errors::TypeCastingError, "Expected to be a string value, got #{value.inspect} for #{field_name}"
      end
    end

  end
end
