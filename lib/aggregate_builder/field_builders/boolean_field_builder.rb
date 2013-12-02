module AggregateBuilder
  class FieldBuilders::BooleanFieldBuilder < FieldBuilders::PrimitiveFieldBuilder

    def self.cast(field_name, value)
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
          raise Errors::TypeCastingError, "Expected to be a boolean value, got #{value.inspect} for #{field_name}"
        end
      elsif value.nil?
        raise Errors::TypeCastingError, "#{field_name} can't be nil"
      else
        raise Errors::TypeCastingError, "Expected to be a boolean value, got #{value.inspect} for #{field_name}"
      end
    end

  end
end
