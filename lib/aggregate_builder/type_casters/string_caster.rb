module AggregateBuilder
  module TypeCasters
    class StringCaster
      class << self
        def clean(value)
          if value.nil? || value.is_a?(String)
            value
          else
            raise Errors::TypeCastingError, "Unable to process string value"
          end
        end
      end
    end
  end
end
