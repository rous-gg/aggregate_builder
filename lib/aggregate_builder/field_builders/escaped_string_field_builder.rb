require 'cgi'

module AggregateBuilder
  class FieldBuilders::EscapedStringFieldBuilder < FieldBuilders::PrimitiveFieldBuilder

    def self.cast(field_name, value)
      if value.is_a?(String)
        string = value
      elsif value.is_a?(Symbol)
        string = value.to_s
      elsif value.nil?
        raise Errors::TypeCastingError, "#{field_name} can't be nil"
      else
        raise Errors::TypeCastingError, "Expected to be a string value, got #{value.inspect} for #{field_name}"
      end
      CGI::escapeHTML(string)
    end

  end
end
