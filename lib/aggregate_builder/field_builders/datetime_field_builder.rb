require 'date'
require 'time'

module AggregateBuilder
  class FieldBuilders::DatetimeFieldBuilder < FieldBuilders::PrimitiveFieldBuilder

    def self.cast(field_name, value)
      return nil if value.nil?
      if value.is_a?(Time)
        value.to_datetime
      elsif value.is_a?(DateTime)
        value
      elsif value.is_a?(String)
        DateTime.parse(value)
      else
        raise Errors::TypeCastingError, "Expected to be a time value, got #{value.inspec} for #{field_name}"
      end
    rescue => e
      raise Errors::TypeCastingError, "Expected to be a time value, got #{value.inspect} for #{field_name}"
    end

  end
end
