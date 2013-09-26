require 'time'

module AggregateBuilder
  module Cleaners
    class Time
      class << self
        def clean(value)
          Time.new(value.to_s)
        rescue ArgumentError
          nil
        end
      end
    end
  end
end
