module AggregateBuilder
  class FieldBuilders::SymbolFieldBuilder < FieldBuilders::PrimitiveFieldBuilder
    MAX_SYMBOL_LENGTH = 1000

    def self.cast(field, value)
      if value.nil? || value.is_a?(Symbol)
        value
      elsif value.is_a?(String)
        if value.length > MAX_SYMBOL_LENGTH
          raise Errors::TypeCastingError, "Expected to be a symbol value, but given too long string #{value[0...MAX_SYMBOL_LENGTH]}... for #{field.field_name}"
        end
        value.to_sym
      else
        raise Errors::TypeCastingError, "Expected to be a string value, got #{value.inspect} for #{field.field_name}"
      end
    end

  end
end
