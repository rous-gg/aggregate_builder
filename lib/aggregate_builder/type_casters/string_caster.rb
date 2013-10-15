module AggregateBuilder
  module TypeCasters
    class StringCaster < SingleValueBuilder
      class << self
        def clean(value)
          if value.nil? || value.is_a?(String)
            value
          elsif value.is_a?(Symbol)
            value.to_s
          else
            raise Errors::TypeCastingError, "Unable to process value, got #{value}"
          end
        end
      end
    end
  end
end
