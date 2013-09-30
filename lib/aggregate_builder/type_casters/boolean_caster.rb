module AggregateBuilder
  module TypeCasters
    class BooleanCaster
      class << self
        def clean(value)
          if [TrueClass, FalseClass, NilClass].include?(value.class)
            value
          elsif value.is_a?(Integer)
            value == 0 ? false : true
          elsif value.is_a?(String)
            if ['y', 'yes', '1'].include?(value.downcase)
              true
            elsif ['n', 'no', '0'].include?(value)
              false
            else
              raise Errors::TypeCastingError, "Unable to process boolean value"
            end
          else
            raise Errors::TypeCastingError, "Unable to process boolean value"
          end
        end
      end
    end
  end
end
