module AggregateBuilder
  class FieldBuilders::BooleanFieldBuilder < FieldBuilders::PrimitiveFieldBuilder

    def self.cast(field, value)
      if [TrueClass, FalseClass, NilClass].include?(value.class)
        value
      elsif value.is_a?(Integer)
        value == 0 ? false : true
      elsif value.is_a?(String)
        if ['true', 'y', 'yes', '1'].include?(value.downcase)
          true
        elsif ['false', 'n', 'no', '0'].include?(value)
          false
        else
          raise Errors::TypeCastingError, "Expected to be a boolean value, got #{value.inspect} for #{field.field_name}"
        end
      else
        raise Errors::TypeCastingError, "Expected to be a boolean value, got #{value.inspect} for #{field.field_name}"
      end
    end

  end
end
