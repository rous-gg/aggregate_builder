module AggregateBuilder
  class TypeCasters::HashTypeCaster

    def self.cast(value)
      unless value.is_a?(Hash)
        raise Errors::TypeCastingError, "Expected to be a hash, got #{value}"
      end
      value
    end

  end
end
