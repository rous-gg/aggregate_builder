module AggregateBuilder
  module TypeCasters
    class BooleanCaster
      class << self
        def clean(value)
          if [TrueClass, FalseClass, NilClass].include?(value.class)
            value
            # TODO: implement extra processing here
          else
            raise Errors::TypeCastingError, "Unable to process boolean value"
          end
        end
      end
    end
  end
end
