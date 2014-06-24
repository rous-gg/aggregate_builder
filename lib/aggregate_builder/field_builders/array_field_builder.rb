module AggregateBuilder
  class FieldBuilders::ArrayFieldBuilder < FieldBuilders::PrimitiveFieldBuilder

    def self.build(field, field_value, object, config, methods_context)
      field_value = cast(field.field_name, field_value)
      if field.options[:immutable]
        previous_field_value = object.send(field.field_name)
        if previous_field_value && previous_field_value != field_value
          raise Errors::ImmutableFieldError, "#{field.field_name} can not be changed, got #{field_value.inspect}"
        end
      end
      object.send("#{field.field_name}=", field_value)
    end

    def self.cast(field_name, value)
      if value.is_a?(Array)
        value
      elsif value.nil?
        raise Errors::TypeCastingError, "#{field_name} can't be nil"
      else
        raise Errors::TypeCastingError, "Expected to be an array, got #{value.inspect} for #{field_name}"
      end
    end

  end
end
