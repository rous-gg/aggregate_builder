require 'time'

module AggregateBuilder::FieldBuilders
  class TimeFieldBuilder < SingleValueFieldBuilder
    class << self

      def clean(value)
        if value.is_a?(Time) || value.nil?
          value
        elsif value.is_a?(String)
          Time.new(value)
        else
          raise Errors::TypeCastingError, "Unable to process time value"
        end
      rescue => e
        raise Errors::TypeCastingError, "Unable to process time value"
      end

    end
  end
end
