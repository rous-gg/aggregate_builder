module AggregateBuilder
  class TypeCasters::IntegerTypeCaster

    def self.cast(value)
      if value.is_a?(Integer) || value.nil?
        value
      elsif value.is_a?(String)
        Integer(value)
      else
        raise Errors::TypeCastingError, "Expected to be an integer value, got #{value}"
      end
    rescue => e
      raise Errors::TypeCastingError, "Expected to be an integer value, got #{value}"
    end

  end
end
