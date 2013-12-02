require 'date'

module AggregateBuilder
  class FieldBuilders::DateFieldBuilder < FieldBuilders::PrimitiveFieldBuilder

    def self.cast(field_name, value)
      if value.is_a?(String)
        Date.parse(value.to_s)
      elsif value.is_a?(Date)
        value
      elsif value.nil?
        raise Errors::TypeCastingError, "#{field_name} can't be nil"
      else
        raise Errors::TypeCastingError, "Expected to be a date value, got #{value.inspect} for #{field_name}"
      end
    rescue ArgumentError => e
      raise Errors::TypeCastingError, "Expected to be a date value, got #{value} for #{field_name}"
    end

  end
end
