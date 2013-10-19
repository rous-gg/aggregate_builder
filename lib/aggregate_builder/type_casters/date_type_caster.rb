require 'date'

module AggregateBuilder
  class TypeCasters::DateTypeCaster

    def self.cast(value)
      if value.nil?
        value
      elsif value.is_a?(String)
        Date.parse(value.to_s)
      elsif value.is_a?(Date)
        value
      else
        raise Errors::TypeCastingError, "Expected to be a date value, got #{value}"
      end
    rescue => e
      raise Errors::TypeCastingError, "Expected to be a date value, got #{value}"
    end

  end
end
