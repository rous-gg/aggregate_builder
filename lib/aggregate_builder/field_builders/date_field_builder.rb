require 'date'

module AggregateBuilder
  class FieldBuilders::DateFieldBuilder < FieldBuilders::PrimitiveFieldBuilder

    def self.cast(field, value)
      if value.nil?
        value
      elsif value.is_a?(String)
        Date.parse(value.to_s)
      elsif value.is_a?(Date)
        value
      else
        raise Errors::TypeCastingError, "Expected to be a date value, got #{value.inspect} for #{field.field_name}"
      end
    rescue => e
      raise Errors::TypeCastingError, "Expected to be a date value, got #{value} for #{field.field_name}"
    end

  end
end
