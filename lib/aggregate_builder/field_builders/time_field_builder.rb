require 'time'

module AggregateBuilder
  class FieldBuilders::TimeFieldBuilder < FieldBuilders::PrimitiveFieldBuilder

    def self.cast(field, value)
      if value.is_a?(Time) || value.nil?
        value
      elsif value.is_a?(String)
        Time.new(value)
      else
        raise Errors::TypeCastingError, "Expected to be a time value, got #{value.inspec} for #{field.field_name}"
      end
    rescue => e
      raise Errors::TypeCastingError, "Expected to be a time value, got #{value.inspect} for #{field.field_name}"
    end

  end
end
