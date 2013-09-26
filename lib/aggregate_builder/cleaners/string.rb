module AggregateBuilder
  module Cleaners
    class String
      class << self
        def clean(value)
          value.to_s
        end
      end
    end
  end
end
