module AggregateBuilder
  module Cleaners
    class Boolean
      class << self
        def clean(value)
          case value
          when TrueClass, FalseClass
            value
          else
            nil
          end
        end
      end
    end
  end
end
