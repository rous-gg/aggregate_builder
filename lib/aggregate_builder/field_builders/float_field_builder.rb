module AggregateBuilder
  module FieldBuilders
    class FloatFieldBuilder < SingleValueFieldBuilder
      class << self
        def clean(value)
          if value.is_a?(Float) || value.nil?
            value
          elsif value.is_a?(String)
            Float(value)
          else
            raise Errors::TypeCastingError, "Unable to process float value"
          end
        rescue => e
          raise Errors::TypeCastingError, "Unable to process float value"
        end
      end
    end
  end
end
