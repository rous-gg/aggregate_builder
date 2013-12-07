module AggregateBuilder
  class FieldBuilders::UrlFieldBuilder < FieldBuilders::PrimitiveFieldBuilder
    MAX_SYMBOL_LENGTH = 100
    URL_REGEXP = /^(https?:\/\/)?([\w\.]+)\.([a-z]{2,6}\.?)(\/[\w\.]*)*\/?$/

    def self.cast(field_name, value)
      if value.is_a?(String)
        if value.length > MAX_SYMBOL_LENGTH
          raise Errors::TypeCastingError, "Given string is too long #{value[0...MAX_SYMBOL_LENGTH]}... for #{field.field_name}"
        end
        unless !!URL_REGEXP.match(value)
          raise Errors::TypeCastingError, "Expected to be a url, got #{value.inspect} for #{field_name}"
        end
        value
      elsif value.nil?
        raise Errors::TypeCastingError, "#{field_name} can't be nil"
      else
        raise Errors::TypeCastingError, "Expected to be a string value, got #{value.inspect} for #{field_name}"
      end
    end

  end
end
