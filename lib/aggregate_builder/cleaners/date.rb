require 'date'

module AggregateBuilder
  module Cleaners
    class Date
      class << self
        def clean(value)
          Date.parse(value.to_s)
        rescue ArgumentError
          nil
        end
      end
    end
  end
end
