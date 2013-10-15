module AggregateBuilder
  module FieldBuilders
    class ArrayOfHashesFieldBuilder < MultipleValueFieldBuilder
      class << self
        def clean(value)
          unless value.is_a?(Array)
            raise Errors::TypeCastingError, "Expected to be an array, got #{value}"
          end
          unless value.all?{|i| i.is_a?(Hash) }
            raise Errors::TypeCastingError, "Expected to be an array of hashes, got #{value}"
          end
          value
        end
      end
    end
  end
end
