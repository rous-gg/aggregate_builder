require 'time'

module AggregateBuilder
  class FieldBuilders::TimeFieldBuilder < FieldBuilders::PrimitiveFieldBuilder

    def self.cast(value)
      if value.is_a?(Time) || value.nil?
        value
      elsif value.is_a?(String)
        Time.new(value)
      else
        raise Errors::TypeCastingError, "Expected to be a time value, got #{value}"
      end
    rescue => e
      raise Errors::TypeCastingError, "Expected to be a time value, got #{value}"
    end

  end
end
