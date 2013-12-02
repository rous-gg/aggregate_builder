module AggregateBuilder
  class FieldBuilders::SymbolFieldBuilder < FieldBuilders::PrimitiveFieldBuilder
    MAX_SYMBOL_LENGTH = 1000

    def self.cast(field_name, value)
      if value.is_a?(Symbol)
        value
      elsif value.is_a?(String)
        if value.length > MAX_SYMBOL_LENGTH
          raise Errors::TypeCastingError, "Expected to be a symbol value, but given too long string #{value[0...MAX_SYMBOL_LENGTH]}... for #{field.field_name}"
        end
        value.to_sym
      elsif value.nil?
        raise Errors::TypeCastingError, "#{field_name} can't be nil"
      else
        raise Errors::TypeCastingError, "Expected to be a string value, got #{value.inspect} for #{field_name}"
      end
    end

  end
end
