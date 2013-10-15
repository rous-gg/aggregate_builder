module AggregateBuilder::FieldBuilders
  class IntegerFieldBuilder < SingleValueFieldBuilder
    class << self

      def clean(value)
        if value.is_a?(Integer) || value.nil?
          value
        elsif value.is_a?(String)
          Integer(value)
        else
          raise Errors::TypeCastingError, "Unable to process integer value"
        end
      rescue => e
        raise Errors::TypeCastingError, "Unable to process integer value"
      end

    end
  end
end
