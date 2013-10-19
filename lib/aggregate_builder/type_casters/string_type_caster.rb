module AggregateBuilder
  class TypeCasters::StringTypeCaster

    def self.cast(value)
      if value.nil? || value.is_a?(String)
        value
      elsif value.is_a?(Symbol)
        value.to_s
      else
        raise Errors::TypeCastingError, "Expected to be a string value, got '#{value}'"
      end
    end

  end
end
