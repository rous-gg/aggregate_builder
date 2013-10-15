require 'date'

module AggregateBuilder
  module TypeCasters
    class DateCaster < SingleValueBuilder
      class << self
        def clean(value)
          if value.nil?
            value
          elsif value.is_a?(String)
            Date.parse(value.to_s)
          elsif value.is_a?(Date)
            value
          else
            raise Errors::TypeCastingError, "Unable to process date value"
          end
        rescue => e
          raise Errors::TypeCastingError, "Unable to process date value"
        end
      end
    end
  end
end
