module AggregateBuilder
  module Cleaners
    class Float
      class << self
        def clean(value)
          Float(value)
        rescue ArgumentError
          nil
        end
      end
    end
  end
end
