module AggregateBuilder
  module Cleaners
    class Integer
      class << self
        def clean(value)
          Integer(value)
        rescue ArgumentError
          nil
        end
      end
    end
  end
end
